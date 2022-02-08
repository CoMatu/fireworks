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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SinCanvas(),
    );
  }
}

class SinCanvas extends StatelessWidget {
  const SinCanvas({Key? key}) : super(key: key);

  static const radius = 200.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        size: const Size(400, 400),
        painter: SinPainter(
          radius: radius,
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

    final points =
        List.generate(itemNumber, (index) => Offset(radius / 2, radius / 2));

    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
