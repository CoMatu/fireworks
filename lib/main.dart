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
      debugShowCheckedModeBanner: false,
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
        children: [
          const Positioned(
            top: -70.0,
            right: -100.0,
            child: Fireworks(
              size: Size(500.0, 500.0),
              itemCount: 15,
              itemWidthMin: 2.0,
              itemWidthMax: 9.0,
              delayStart: 0,
              duration: 1500,
              color: Colors.red,
            ),
          ),
          const Positioned(
            top: 350.0,
            right: 300.0,
            child: Fireworks(
              size: Size(300.0, 300.0),
              itemCount: 15,
              itemWidthMin: 2.0,
              itemWidthMax: 10.0,
              delayStart: 200,
              duration: 800,
            ),
          ),
          const Positioned(
            top: 0,
            right: -40.0,
            child: Fireworks(
              size: Size(130.0, 130.0),
              itemCount: 12,
              itemWidthMin: 2.0,
              itemWidthMax: 8.0,
              delayStart: 400,
              color: Color.fromARGB(255, 205, 254, 252),
            ),
          ),
          const Positioned(
            top: 400.0,
            right: -60.0,
            child: Fireworks(
              size: Size(130.0, 130.0),
              itemCount: 12,
              itemWidthMin: 2.0,
              itemWidthMax: 8.0,
              delayStart: 550,
              color: Colors.yellow,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3,
            right: 100.0,
            child: const Fireworks(
              size: Size(200.0, 200.0),
              itemCount: 12,
              itemWidthMin: 2.0,
              itemWidthMax: 5.0,
              delayStart: 300,
              duration: 1300,
            ),
          ),
          const Positioned(
            bottom: -50,
            right: 100.0,
            child: Fireworks(
              size: Size(200.0, 200.0),
              itemCount: 12,
              itemWidthMin: 2.0,
              itemWidthMax: 5.0,
              delayStart: 300,
              duration: 1300,
              color: Color.fromARGB(255, 82, 255, 243),
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
    required this.itemWidthMin,
    required this.itemWidthMax,
    this.delayStart = 0,
    this.duration = 1000,
    this.color = Colors.white,
  }) : super(key: key);

  /// Количество точек по окружности
  final int itemCount;

  /// Стартовый диаметр точки
  final double itemWidthMin;

  /// Диаметр точки в конце анимации
  final double itemWidthMax;

  /// Цвет точки
  final Color color;

  /// Размер холста
  final Size size;

  /// Задержка старта анимации, миллисекунд
  final int delayStart;

  /// Длительность анимации фейерверка, миллисекунд
  final int duration;

  @override
  State<Fireworks> createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks> with TickerProviderStateMixin {
  final List<double> positions = [];

  double radius = 0.0;
  double itemWidthMin = 2.0;
  double itemWidthMax = 12.0;

  late final AnimationController controller;
  late final AnimationController sizeController;

  /// Тип анимации для скорости разлёта точек
  late final Animation<double> animation;

  /// Тип анимации для изменения размера (диаметра) точек
  late final Animation<double> animationSize;

  late final Duration delay;

  @override
  void initState() {
    delay = Duration(milliseconds: widget.delayStart);

    itemWidthMin = widget.itemWidthMin;
    itemWidthMax = widget.itemWidthMax;

    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.duration,
        ))
      ..addListener(animationListener);

    sizeController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.duration,
        ))
      ..addListener(animationListener);

    animation =
        Tween(begin: 0.0, end: widget.size.height / 2).animate(controller);

    final _animationSize = CurvedAnimation(
      parent: sizeController,
      curve: Curves.easeIn,
    );

    animationSize =
        Tween(begin: 0.0, end: itemWidthMax).animate(_animationSize);

    Future.delayed(delay).then((value) => controller.forward());
    Future.delayed(delay).then((value) => sizeController.forward());

    super.initState();
  }

  void animationListener() async {
    if (controller.isCompleted) {
      controller.repeat();
      sizeController.repeat();
    }

    setState(() {
      radius = animation.value;
      itemWidthMin = animationSize.value;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FireworksCanvas(
      radius: radius,
      itemWidth: itemWidthMin,
      itemNumber: widget.itemCount,
      size: widget.size,
      color: widget.color,
    );
  }
}

class FireworksCanvas extends StatelessWidget {
  const FireworksCanvas({
    Key? key,
    required this.radius,
    required this.itemWidth,
    required this.itemNumber,
    required this.size,
    required this.color,
  }) : super(key: key);

  final double radius;
  final double itemWidth;
  final int itemNumber;
  final Size size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // log(radius.toString());

    return CustomPaint(
      size: size,
      painter: FireworksPainter(
        radius: radius,
        itemNumber: itemNumber,
        itemWidth: itemWidth,
        color: color,
      ),
    );
  }
}

class FireworksPainter extends CustomPainter {
  final double radius;
  final int itemNumber;
  final double itemWidth;
  final Color color;

  FireworksPainter({
    required this.radius,
    required this.itemWidth,
    required this.color,
    this.itemNumber = 12,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = itemWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final points = List.generate(
      itemNumber,
      (index) {
        final double angle =
            (2 * m.pi / itemNumber) + (2 * m.pi / itemNumber) * (index + 1);
        return Offset(
          size.width / 2 + radius * m.cos(angle),
          size.width / 2 + radius * m.sin(angle),
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
