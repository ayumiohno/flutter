import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:new_flutter/frame.dart';
import 'package:screenshot/screenshot.dart';
import 'package:new_flutter/background.dart';
import 'package:cross_file_image/cross_file_image.dart';

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
  Widget shareFrame = ShareFrame(
    Image.asset('assets/image.png'),
  );
  @override
  Widget build(BuildContext context) {
    if (widget.image != null) {
      shareFrame = ShareFrame(
        Image(image: XFileImage(widget.image as XFile)),
      );
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Icon(Icons.arrow_back_ios),
            title: const Text('Share'),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.74,
                child: Background(shareFrame),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.04,
                  right: constraints.maxWidth * 0.04,
                  top: constraints.maxHeight * 0.038,
                  bottom: constraints.maxHeight * 0.038,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _downloadWidget();
                      },
                      icon: Icon(Icons.download, color: Colors.black),
                      label: Text('Download',
                          style: TextStyle(color: Colors.black)),
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
                        minimumSize: Size(constraints.maxWidth * 0.50,
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
      shareFrame,
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
      shareFrame,
    )
        .then((image) {
      if (image != null) {
        final buffer = image.buffer;
      }
    });
  }
}
