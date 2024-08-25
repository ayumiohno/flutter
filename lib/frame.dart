import 'package:flutter/material.dart';

class ShareFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerPadding = constraints.maxWidth * 0.05;
        return Center(
          child: Container(
            padding: EdgeInsets.all(containerPadding),
            color: Colors.blue[50],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    // Family image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/image.png', // Replace with your image path
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Top-left icon
                    Positioned(
                      top: containerPadding * 0.5,
                      left: containerPadding * 0.5,
                      child: Icon(
                        Icons.pets,
                        size: constraints.maxWidth * 0.1,
                        color: Colors.white,
                      ),
                    ),
                    // Bottom-right icon
                    Positioned(
                      bottom: containerPadding * 0.5,
                      right: containerPadding * 0.5,
                      child: Icon(
                        Icons.pets,
                        size: constraints.maxWidth * 0.1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: containerPadding * 0.5),
                // Product info
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/image.png', // Replace with your icon path
                        width: constraints.maxWidth * 0.1,
                        height: constraints.maxWidth * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: containerPadding * 0.5),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
