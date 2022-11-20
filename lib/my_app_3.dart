import 'dart:ui';

import 'package:flutter/material.dart';

class MyApp3 extends StatefulWidget {
  const MyApp3({super.key});

  @override
  State<MyApp3> createState() => _MyApp3State();
}

class _MyApp3State extends State<MyApp3> with TickerProviderStateMixin {
  double updateTime = 0.0;
  var _move = 0.0, _stop = 0.0;

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
              final shader = snapshot.data!.fragmentShader()
                ..setFloat(0, updateTime)
                ..setFloat(1, 300)
                ..setFloat(2, 300)
                ..setFloat(3, _move)
                ..setFloat(4, _stop);
              return Stack(
                children: [
                  CustomPaint(painter: AnimRect(shader)),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      child: _move == 1.0
                          ? Icon(Icons.compare_arrows_outlined)
                          : Icon(Icons.arrow_circle_up),
                      onPressed: () {
                        setState(() {
                          if (_move == 1) {
                            _move = 0.0;
                          } else {
                            _move = 1;
                          }
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: _stop == 1.0
                          ? const Icon(Icons.play_arrow)
                          : const Icon(Icons.stop),
                      onPressed: () {
                        setState(() {
                          if (_stop == 1.0) {
                            _stop = 0.0;
                          } else {
                            _stop = 1.0;
                          }
                        });
                      },
                    ),
                  ),
                ],
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
    return FragmentProgram.fromAsset('shaders/shader_sky_move.glsl');
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
