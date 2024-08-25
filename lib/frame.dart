import 'package:flutter/material.dart';

class ShareFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerPadding = constraints.maxWidth * 0.05;
        return Center(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    // Family image
                    Padding(
                      padding: EdgeInsets.all(containerPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/image.png', // Replace with your image path
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Top-left icon
                    Positioned(
                      top: containerPadding * 0.05,
                      left: containerPadding * 0.05,
                      child: Image.asset(
                        'assets/icon2.png',
                        width: constraints.maxWidth * 0.2,
                        height: constraints.maxWidth * 0.2,
                      ),
                    ),
                    // Bottom-right icon
                    Positioned(
                      bottom: containerPadding * 0.1,
                      right: containerPadding * 0.1,
                      child: Image.asset(
                        'assets/icon1.png',
                        width: constraints.maxWidth * 0.2,
                        height: constraints.maxWidth * 0.2,
                      ),
                    ),
                  ],
                ),
                // Product info
                Container(
                  padding: EdgeInsets.only(
                    left: containerPadding,
                    right: containerPadding,
                    bottom: containerPadding,
                  ),
                  child: Row(
                    children: [
                      Stack(children: [
                        Padding(
                          padding: EdgeInsets.all(containerPadding * 0.5),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Name',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.05,
                              fontWeight: FontWeight.bold,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
