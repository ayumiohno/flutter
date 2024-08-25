import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerPadding = constraints.maxWidth * 0.05;
        return Row(
          children: [
            Stack(children: [
              Padding(
                padding: EdgeInsets.only(
                  left: containerPadding * 0.5,
                  right: containerPadding * 0.5,
                  bottom: containerPadding,
                ),
                child: Image.asset(
                  'assets/product.png',
                  width: constraints.maxWidth * 0.25,
                  height: constraints.maxWidth * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/logo.png',
                    width: constraints.maxWidth * 0.1,
                    height: constraints.maxWidth * 0.1,
                  )),
            ]),
            SizedBox(width: containerPadding),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Name',
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '26.08.2024',
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.04,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
