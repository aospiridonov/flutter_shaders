import 'dart:ui';

import 'package:flutter/material.dart';

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> with TickerProviderStateMixin {
  double updateTime = 0.0;

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    }).start();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: _initShader(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final shader = snapshot.data!.fragmentShader()
            ..setFloat(0, updateTime)
            ..setFloat(1, 300)
            ..setFloat(2, 300);
          return CustomPaint(
            painter: AnimRect(shader),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<FragmentProgram> _initShader() {
    return FragmentProgram.fromAsset('shaders/shader1.glsl');
  }
}

class AnimRect extends CustomPainter {
  final Shader shader;

  AnimRect(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.largest, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
