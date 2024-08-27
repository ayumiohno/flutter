import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:new_flutter/frame.dart';

import 'package:new_flutter/frame3.dart';
import 'package:new_flutter/background3.dart';

import 'package:new_flutter/frame_good.dart';
import 'package:screenshot/screenshot.dart';
import 'package:new_flutter/background.dart';
import 'package:new_flutter/background_good.dart';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondPage extends StatefulWidget {
  final XFile? image; //上位Widgetから受け取りたいデータ

  const SecondPage({
    super.key,
    required this.image,
  });

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  Widget frame = NormalFrame(
    Image.asset('assets/image.png'),
  );
  Widget background =
      NormalBackground(NormalFrame(Image.asset('assets/image.png')));
  String pose = '';

  @override
  void initState() {
    super.initState();
    frame = NormalFrame(
      Image(image: XFileImage(widget.image as XFile)),
    );
    background = NormalBackground(frame);
    _sendRequest(widget.image as XFile);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Share'),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.74,
                child: background,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 32.0,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _downloadWidget();
                      },
                      icon: Icon(Icons.download, color: Colors.black),
                      label: Text(pose, style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        minimumSize: Size(constraints.maxWidth * 0.30,
                            constraints.maxHeight * 0.05),
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth * 0.04),
                    ElevatedButton.icon(
                      onPressed: () {
                        _shareWidget();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      label:
                          Text('Share', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color(0xFF5E6DF2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        minimumSize: Size(constraints.maxWidth * 0.52,
                            constraints.maxHeight * 0.05),
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            ],
          ));
    });
  }

  void _shareWidget() {
    screenshotController
        .captureFromWidget(
      frame,
    )
        .then((image) {
      if (image != null) {
        final buffer = image.buffer;
        Share.shareXFiles(
          [
            XFile.fromData(
              buffer.asUint8List(
                image.offsetInBytes,
                image.lengthInBytes,
              ),
              name: 'Photo.png',
              mimeType: 'image/png',
            ),
          ],
          text: 'Check out this cool app!',
        );
      }
    });
  }

  void _downloadWidget() {
    screenshotController
        .captureFromWidget(
      frame,
    )
        .then((image) {
      if (image != null) {
        final buffer = image.buffer;
      }
    });
  }

  Future<void> _sendRequest(XFile file) async {
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
      setState(() {
        pose = responseData['message'];
        // TODO: Frameをposeに応じて変更
        if (pose == 'thumbs up') {
          frame = FrameForThumbsUp(
            Image(image: XFileImage(widget.image as XFile)),
          );
          background = BackgroundForThumbsUp(frame);
        } else if (pose == "shoulder") {
          frame = FrameForShoulder(
            Image(image: XFileImage(widget.image as XFile)),
          );
          background = BackgroundForShoulder(frame);
        }
      });
    } else {
      debugPrint('Error: ${response.reasonPhrase}');
    }
  }
}
