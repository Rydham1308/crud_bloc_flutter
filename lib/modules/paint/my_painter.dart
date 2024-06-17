import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:task_crud/modules/paint/shape_painter.dart';

@RoutePage()
class MyPainter extends StatelessWidget {
  const MyPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lines'),
      ),
      body: CustomPaint(
        painter: ShapePainter(),
        child: Container(),
      ),
    );
  }
}
