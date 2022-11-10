import 'dart:ui';

import 'package:flutter/material.dart';

class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> with TickerProviderStateMixin {
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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<FragmentProgram>(
          future: _initShader(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ShaderMask(
                shaderCallback: ((bounds) {
                  return snapshot.data!.fragmentShader()
                    ..setFloat(0, updateTime)
                    ..setFloat(1, bounds.height)
                    ..setFloat(2, bounds.width);
                }),
                child: const Center(
                  child: Text(
                    'TEST',
                    style: TextStyle(
                      fontSize: 150,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<FragmentProgram> _initShader() {
    return FragmentProgram.fromAsset('shaders/shader_sky.glsl');
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
