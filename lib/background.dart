import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  final Widget frame;
  Background(this.frame);

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: Stack(
          children: [
            Positioned(
                top: constraints.maxHeight * 0.05,
                right: constraints.maxWidth * 0.05,
                child: Image.asset(
                  'assets/star.png',
                  width: constraints.maxWidth * 0.25,
                  height: constraints.maxWidth * 0.25,
                  fit: BoxFit.cover,
                )),
            Positioned(
              top: constraints.maxHeight * 0.15,
              left: constraints.maxWidth * 0.1,
              child: Transform.rotate(
                angle: -0.174533, // -10 degrees in radians
                child: Container(
                  width: constraints.maxWidth * 0.8,
                  child: frame,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
