import 'dart:convert';
import 'dart:ui' as ui;

import 'package:camellia_manito/pages/game_page_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late GamePageViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = context.read<GamePageViewModel>();
    _viewModel.usersDataListenable.addListener(_refresh);
    _viewModel.resultStatusListenable.addListener(() {
      context.pop(1);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20), // 60FPS
    )..addListener(() {
        setState(() {
          for (var ball in _viewModel.balls) {
            ball.update();
          }
        });
      });

    _viewModel.init();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.usersDataListenable.removeListener(_refresh);
    _viewModel.resultStatusListenable.removeListener(_refresh);

    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.red,
              Colors.lightGreen,
              Colors.red,
              Colors.lightGreenAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: BallPainter(_viewModel.balls),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.5,
                  left: MediaQuery.of(context).size.height / 10,
                  child: Image.asset(
                    'assets/images/wait.png',
                    width: 200,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

/// 📌 공 클래스 (위치, 속도, 반지름, Base64 이미지, 보더 색상 포함)
class Ball {
  double x, y;
  double dx, dy;
  double radius;
  String base64Image;
  ui.Image? image;
  Color borderColor; // ✅ 보더 색상 추가

  Ball({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
    required this.base64Image,
    required this.borderColor, // ✅ 랜덤 보더 색상
  }) {
    _decodeImage(); // 이미지 디코딩
  }

  /// 📌 Base64 이미지를 디코딩
  Future<void> _decodeImage() async {
    if (base64Image.isNotEmpty) {
      final Uint8List imageBytes = base64Decode(base64Image);
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      image = frameInfo.image;
    }
  }

  /// 📌 공 위치 업데이트 (화면 경계 충돌 반사)
  void update() {
    x += dx;
    y += dy;

    if (x - radius < 0 || x + radius > 400) {
      dx = -dx;
    }
    if (y - radius < 0 || y + radius > 700) {
      dy = -dy;
    }
  }
}

/// 📌 Base64 이미지를 그리는 CustomPainter
class BallPainter extends CustomPainter {
  final List<Ball> balls;

  BallPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    for (var ball in balls) {
      if (ball.image != null) {
        // 원형으로 클리핑
        canvas.save();
        Path clipPath = Path()
          ..addOval(Rect.fromCircle(
              center: Offset(ball.x, ball.y), radius: ball.radius));
        canvas.clipPath(clipPath);

        // 이미지 렌더링
        Rect imageRect = Rect.fromLTWH(
          ball.x - ball.radius,
          ball.y - ball.radius,
          ball.radius * 2,
          ball.radius * 2,
        );
        canvas.drawImageRect(
          ball.image!,
          Rect.fromLTWH(0, 0, ball.image!.width.toDouble(),
              ball.image!.height.toDouble()), // 원본 이미지 크기
          imageRect, // 조정된 이미지 크기
          Paint(),
        );
        canvas.restore();
      }

      // ✅ 공 보더 추가
      final borderPaint = Paint()
        ..color = ball.borderColor // 랜덤 보더 색상
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5; // 보더 두께
      canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
