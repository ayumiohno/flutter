import 'package:flutter/material.dart';

class BackgroundForShoulder extends StatelessWidget {
  @override
  final Widget frame;
  BackgroundForShoulder(this.frame);

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final linesX = 17;
      double gridSpace = constraints.maxWidth / linesX;
      final linesY = (constraints.maxHeight / gridSpace).round();
      var h = Container(
          width: 1.61, height: constraints.maxHeight, color: Colors.white);
      var v = Container(
          width: constraints.maxWidth, height: 1.61, color: Colors.white);
      return Container(
        color: Color.fromRGBO(227, 244, 250, 1.0),
        child: Stack(
          children: [
            ...List.generate(linesX,
                (index) => Positioned(left: index * gridSpace, child: h)),
            ...List.generate(linesY,
                (index) => Positioned(top: index * gridSpace, child: v)),
            Positioned(
                top: 50,
                right: 5,
                child: Transform.rotate(
                    angle: 0,
                    child: Image.asset(
                      'assets/icon3-1.png',
                      width: 55.53,
                      fit: BoxFit.cover,
                    ))),
            Positioned(
                top: 150,
                right: 10,
                child: Transform.rotate(
                    angle: 0,
                    child: Image.asset(
                      'assets/icon3-3.png',
                      width: 21.41,
                      height: 20.41,
                      fit: BoxFit.cover,
                    ))),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                'assets/icon3-4.png',
                width: 150,
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
