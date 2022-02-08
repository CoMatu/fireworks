import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Fireworks(
        size: Size(400, 400),
      ),
    );
  }
}

class Fireworks extends StatefulWidget {
  const Fireworks({
    Key? key,
    this.itemCount = 12,
    required this.size,
  }) : super(key: key);

  final int itemCount;
  final Size size;

  @override
  State<Fireworks> createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks> {
  final List<double> positions = [];

  double radius = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SinCanvas(
        radius: radius,
      ),
    );
  }
}

class SinCanvas extends StatelessWidget {
  const SinCanvas({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.orangeAccent,
        child: CustomPaint(
          size: const Size(400, 400),
          painter: SinPainter(
            radius: radius,
          ),
        ),
      ),
    );
  }
}

class SinPainter extends CustomPainter {
  final double radius;
  final int itemNumber;

  SinPainter({
    required this.radius,
    this.itemNumber = 12,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = Colors.black;

    final points = List.generate(
      itemNumber,
      (index) {
        final double angle =
            (2 * pi / itemNumber) + (2 * pi / itemNumber) * (index + 1);
        return Offset(
          200 + radius * cos(angle),
          200 + radius * sin(angle),
        );
      },
    );

    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
