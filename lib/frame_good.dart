import 'package:flutter/material.dart';
import 'package:new_flutter/product_info.dart';

class FrameForThumbsUp extends StatelessWidget {
  @override
  final Widget image;
  FrameForThumbsUp(this.image);

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerPadding = constraints.maxWidth * 0.1;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: containerPadding,
                        right: containerPadding,
                        top: containerPadding,
                        bottom: containerPadding * 0.67),
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: image,
                        )),
                  ),
                  Positioned(
                    top: containerPadding * 0.03,
                    right: containerPadding * 0.03,
                    child: Image.asset(
                      'assets/thumes_up_character.png',
                      width: 68,
                    ),
                  ),
                  Positioned(
                    bottom: containerPadding * 0.1,
                    left: containerPadding * 0.1,
                    child: Image.asset(
                      'assets/family_character.png',
                      width: 90.39,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  left: containerPadding * 0.67,
                  right: containerPadding * 0.67,
                  bottom: containerPadding * 0.67,
                ),
                child: ProductInfo(),
              )
            ],
          ),
        );
      },
    );
  }
}