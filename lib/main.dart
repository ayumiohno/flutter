import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:new_flutter/second.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(
    cameras: cameras,
    initialCamera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.cameras, required this.initialCamera});

  final List<CameraDescription> cameras;
  final CameraDescription initialCamera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: CameraScreen(cameras: cameras, initialCamera: initialCamera),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen(
      {super.key, required this.cameras, required this.initialCamera});

  final List<CameraDescription> cameras;
  final CameraDescription initialCamera;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription _currentCamera;
  late FlashMode _flashMode = FlashMode.off;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentCamera = widget.initialCamera;
    _controller = CameraController(
      _currentCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSwitchCamera() async {
    final newCamera = widget.cameras.firstWhere(
      (camera) => camera != _currentCamera,
    );

    setState(() {
      _currentCamera = newCamera;
      _controller = CameraController(
        _currentCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  Future<void> _toggleFlashMode() async {
    setState(() {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.always; // Turn flash on
      } else {
        _flashMode = FlashMode.off; // Turn flash off
      }
    });
    await _controller.setFlashMode(_flashMode);
  }

  Future<void> _toggleZoom() async {
    setState(() {
      _isZoomed = !_isZoomed;
    });
    final zoomLevel = _isZoomed ? 2.0 : 1.0;
    await _controller.setZoomLevel(zoomLevel);
  }

  Future<void> _takePicture() async {
    // 写真を撮る前にフラッシュモードを設定
    await _controller.setFlashMode(_flashMode);
    final image = await _controller.takePicture();

    // 撮影した写真を表示する画面に遷移
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imagePath: image.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: const Text('Camera Preview'),
      ),
      body: Center(
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _flashMode == FlashMode.off
                            ? Icons.flash_off
                            : Icons.flash_on,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.width * 0.1,
                      ),
                      onPressed: _toggleFlashMode,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    ShutterButton(
                      onPressed: () async {
                        // 写真を撮る
                        final image = await _controller.takePicture();
                        showProgressDialog(context);
                        final pose = await _sendRequest(image);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SecondPage(image: image, pose: pose)),
                        );
                        Navigator.of(context, rootNavigator: true).pop();

                        // 撮影した写真を表示する画面に遷移
                        // await Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         DisplayPictureScreen(imagePath: image.path),
                        //   ),
                        // );
                      },
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    IconButton(
                      icon: const Icon(
                        Icons.flip_camera_android_rounded,
                        color: Colors.black,
                        size: 45.0,
                      ),
                      onPressed: _onSwitchCamera,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 250.0,
              right: 20.0,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Columnのサイズを内容に合わせる
                children: [
                  IconButton(
                    icon: Icon(
                      _isZoomed ? Icons.zoom_out : Icons.zoom_in,
                      color: Colors.black,
                    ),
                    onPressed: _toggleZoom,
                    iconSize: 40.0,
                    tooltip: _isZoomed ? "Zoom Out" : "Zoom In",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _sendRequest(XFile file) async {
    final uri = Uri.parse('http://18.209.231.104:8000/predict');
    final request = http.MultipartRequest('POST', uri)
      ..headers['content-type'] = 'multipart/form-data'
      ..headers['upgrade-insecure-requests'] = '1'
      ..fields['Content-Disposition'] =
          'form-data; name="file"; filename="good.jpg"'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      debugPrint('Response: ${response.body}');
      final responseData = json.decode(response.body);
      return responseData['message'];
    } else {
      debugPrint('Error: ${response.reasonPhrase}');
      return 'unknown';
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Picture')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}

class ShutterButton extends StatelessWidget {
  final Function()? onPressed;

  const ShutterButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 64.0;

    return OutlinedButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
        fixedSize: const Size(size, size),
        side: const BorderSide(
          color: Color(0xFF5E6DF2),
          width: 4.0,
        ),
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void showProgressDialog(context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: Duration.zero, // これを入れると遅延を入れなくて
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (BuildContext context, Animation animation,
        Animation secondaryAnimation) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
