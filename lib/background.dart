import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  final Widget frame;
  Background(this.frame);

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final linesX = 17;
      double gridSpace = constraints.maxWidth / linesX;
      final linesY = (constraints.maxHeight / gridSpace).round();
      var h =Container(width: 1.61, height: constraints.maxHeight, color: Colors.white);
      var v =Container(width: constraints.maxWidth, height: 1.61, color: Colors.white);
      return Container(
        color: Color(0xFFF2F3FE),
        child: Stack(
          children: [
            ...List.generate(linesX, (index) => Positioned(left: index * gridSpace, child: h)),
            ...List.generate(linesY, (index) => Positioned(top: index * gridSpace, child: v)),
            Positioned(
                top: 10,
                right: 5,
                child: Transform.rotate(
                    angle: 0.96,
                    child: Image.asset(
                      'assets/star.png',
                      width: 85.19,
                      fit: BoxFit.cover,
                    ))),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                'assets/path.png',
                width: 240,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -0.174533,
                child: Container(
                  width: constraints.maxWidth * 0.85,
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
