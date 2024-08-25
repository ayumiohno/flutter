import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:new_flutter/frame.dart';
import 'package:screenshot/screenshot.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});


  @override
  Widget build(BuildContext context) {
      return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          ShareFrame(),
          // Download button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.033,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Download'),
            ),
          ),
          // Share button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.033,
            right: MediaQuery.of(context).size.width * 0.05,
            child: ElevatedButton(
              onPressed: () async{
                // Share.share('Check out this cool app!');
                ScreenshotController screenshotController = ScreenshotController();
                screenshotController
                    .captureFromWidget(
                  ShareFrame(),
                )
                    .then((image) {
                  // Handle captured image
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
              },
              child: Text('Share'),
            ),
          ),
        ],
      ),
    );
  }
}