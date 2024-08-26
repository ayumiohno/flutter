import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:new_flutter/second.dart';

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
        leading: Icon(Icons.arrow_back_ios),
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
                padding: const EdgeInsets.only(bottom: 130.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _flashMode == FlashMode.off
                            ? Icons.flash_off
                            : Icons.flash_on,
                        color: Colors.black,
                        size: 45.0,
                      ),
                      onPressed: _toggleFlashMode,
                    ),
                    const SizedBox(width: 40.0),
                    ShutterButton(
                      onPressed: () async {
                        // 写真を撮る
                        final image = await _controller.takePicture();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPage(image: image)),
                        );

                        // 撮影した写真を表示する画面に遷移
                        // await Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         DisplayPictureScreen(imagePath: image.path),
                        //   ),
                        // );
                      },
                    ),
                    const SizedBox(width: 40.0),
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
              child: Switch(
                value: _isZoomed,
                onChanged: (value) {
                  _toggleZoom();
                },
                activeColor: Color(0xFF5E6DF2),
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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
