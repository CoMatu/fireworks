import 'dart:developer';
import 'dart:math' as m;
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
      home: const FireworksPage(),
    );
  }
}

class FireworksPage extends StatelessWidget {
  const FireworksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: boxDecoration,
      child: Stack(
        children: const [
          Positioned(
            top: 200,
            right: 100,
            child: Fireworks(
              size: Size(300, 300),
              itemCount: 15,
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: Fireworks(
              size: Size(500, 500),
              itemCount: 15,
            ),
          ),
        ],
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

class _FireworksState extends State<Fireworks> with TickerProviderStateMixin {
  final List<double> positions = [];

  double radius = 0.0;
  double itemWidth = 2.0;
  double itemWidthMax = 12.0;

  late final AnimationController controller;
  late final Animation<double> animation;
  late final Animation<double> animationSize;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ))
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }

        // log(radius.toString());

        setState(() {
          radius = animation.value;
          itemWidth = animationSize.value;
        });
      });
    animation =
        Tween(begin: 0.0, end: widget.size.height / 2).animate(controller);
    animationSize = Tween(begin: 0.0, end: itemWidthMax).animate(controller);

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SinCanvas(
      radius: radius,
      itemWidth: itemWidth,
      itemNumber: widget.itemCount,
      size: widget.size,
    );
  }
}

class SinCanvas extends StatelessWidget {
  const SinCanvas({
    Key? key,
    required this.radius,
    required this.itemWidth,
    required this.itemNumber,
    required this.size,
  }) : super(key: key);

  final double radius;
  final double itemWidth;
  final int itemNumber;
  final Size size;

  @override
  Widget build(BuildContext context) {
    // log(radius.toString());

    return CustomPaint(
      size: size,
      painter: SinPainter(
        radius: radius,
        itemNumber: itemNumber,
        itemWidth: itemWidth,
      ),
    );
  }
}

class SinPainter extends CustomPainter {
  final double radius;
  final int itemNumber;
  final double itemWidth;

  SinPainter({
    required this.radius,
    required this.itemWidth,
    this.itemNumber = 12,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = itemWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    final points = List.generate(
      itemNumber,
      (index) {
        final double angle =
            (2 * m.pi / itemNumber) + (2 * m.pi / itemNumber) * (index + 1);
        return Offset(
          200 + radius * m.cos(angle),
          200 + radius * m.sin(angle),
        );
      },
    );

    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

const boxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF4CD83),
      Color(0xFFFFBB36),
      Color(0xFFFF9A43),
      Color(0xFFFF7257),
      Color(0xFFFF5E4A)
    ],
  ),
);
