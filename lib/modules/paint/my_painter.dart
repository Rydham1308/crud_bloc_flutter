import 'dart:math' as math;

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:task_crud/modules/paint/shape_painter.dart';

@RoutePage()
class MyPainter extends StatefulWidget {
  const MyPainter({super.key});

  @override
  State<MyPainter> createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> with TickerProviderStateMixin  {
  var _sides = 3.0;

  late Animation<double> animation;
  late AnimationController controller;

  late Animation<double> animation2;
  late AnimationController controller2;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    Tween<double> radiusTween = Tween(begin: 0.0, end: 200);
    Tween<double> rotationTween = Tween(begin: -math.pi, end: math.pi);

    animation = rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    animation2 = radiusTween.animate(controller2)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });

    controller.forward();
    controller2.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygons'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, snapshot) {
                  return CustomPaint(
                    painter: ShapePainter(_sides, animation2.value, animation.value),
                    child: Container(),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text('Sides'),
            ),
            Slider(
              value: _sides,
              min: 1.0,
              max: 50.0,
              label: _sides.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _sides = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
