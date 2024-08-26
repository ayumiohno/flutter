import 'package:flutter/material.dart';
import 'package:new_flutter/product_info.dart';

class NormalFrame extends StatelessWidget {
  @override
  final Widget image;
  NormalFrame(this.image);

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
                    top: containerPadding * 0,
                    left: containerPadding * 0,
                    child: Image.asset(
                      'assets/icon2.png',
                      width: 76,
                      height: 78,
                    ),
                  ),
                  Positioned(
                    bottom: containerPadding * 0.1,
                    right: containerPadding * 0.1,
                    child: Image.asset(
                      'assets/icon1.png',
                      width: 74,
                      height: 78,
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
