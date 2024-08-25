import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:new_flutter/frame.dart';
import 'package:screenshot/screenshot.dart';
import 'package:new_flutter/background.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({
    super.key,
  });

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  final Widget shareFrame = ShareFrame(
    Image.asset('assets/image.png'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Background(shareFrame),
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
                onPressed: () async {
                  // Share.share('Check out this cool app!');
                  screenshotController
                      .captureFromWidget(
                    shareFrame,
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
      ),
    );
  }
}
