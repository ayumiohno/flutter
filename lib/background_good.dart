import 'package:flutter/material.dart';

class BackgroundForThumbsUp extends StatelessWidget {
  @override
  final Widget frame;
  BackgroundForThumbsUp(this.frame);

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
        color: Color(0xFFFFF4D6),
        child: Stack(
          children: [
            ...List.generate(linesX,
                (index) => Positioned(left: index * gridSpace, child: h)),
            ...List.generate(linesY,
                (index) => Positioned(top: index * gridSpace, child: v)),
            Positioned(
                top: 23.5,
                right: 10,
                child: Image.asset(
                  'assets/thumes_up_icon.png',
                  width: 50,
                  fit: BoxFit.cover,
                )),
            Positioned(
                top: 89,
                right: 10,
                child: Image.asset(
                  'assets/star_blue.png',
                  width: 32,
                  fit: BoxFit.cover,
                )),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                'assets/path_for_thumes_up.png',
                width: 138,
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
