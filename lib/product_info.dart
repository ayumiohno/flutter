import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

class ProductInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();

    final pacificTimeZone = tz.getLocation('America/Los_Angeles');
    DateTime utcTime = DateTime.now().toUtc();
    DateTime pacificTime = tz.TZDateTime.from(utcTime, pacificTimeZone);
    var formatter = DateFormat('MM.dd.yyyy hh:mm a', "en_US");
    var formatted = formatter.format(pacificTime);

    return LayoutBuilder(
      builder: (context, constraints) {
        double containerPadding = constraints.maxWidth * 0.1;
        return Row(
          children: [
            Stack(children: [
              Padding(
                padding: EdgeInsets.only(
                  left: containerPadding * 0.33,
                  bottom: containerPadding * 0.33,
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
                    width: 32,
                    height: 32,
                  )),
            ]),
            SizedBox(width: containerPadding * 0.67),
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
                  formatted,
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
