import 'dart:io';
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
      _controller.stop();
      Future.delayed(const Duration(seconds: 1), () {
        context.pop(1);
      });
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

/// 📌 공 클래스 (위치, 속도, 반지름, 이미지 파일)
class Ball {
  double x, y;
  double dx, dy;
  double radius;
  String imagePath;
  ui.Image? image;

  Ball({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
    required this.imagePath,
  }) {
    _decodeImage(); // 이미지 디코딩
  }

  /// 📌 기기 저장된 이미지 파일 가져오기
  Future<void> _decodeImage() async {
    if (imagePath.isNotEmpty) {
      try {
        final Uint8List imageBytes = await File(imagePath).readAsBytes();
        final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        image = frameInfo.image;
      } catch (e) {
        print("❌ 이미지 로드 실패: $e");
      }
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

/// 📌 이미지 파일을 그리는 CustomPainter (비율 유지 + 원형 딱 맞게)
class BallPainter extends CustomPainter {
  final List<Ball> balls;

  BallPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    for (var ball in balls) {
      if (ball.image != null) {
        // ✅ 원형으로 클리핑
        canvas.save();
        Path clipPath = Path()
          ..addOval(Rect.fromCircle(
              center: Offset(ball.x, ball.y), radius: ball.radius));
        canvas.clipPath(clipPath);

        // ✅ 원본 이미지 비율 계산
        double imgWidth = ball.image!.width.toDouble();
        double imgHeight = ball.image!.height.toDouble();
        double aspectRatio = imgWidth / imgHeight;

        // ✅ 원형 안에 가득 차도록 크롭 (Crop & Scale)
        double cropSize;
        Rect srcRect;
        if (aspectRatio > 1) {
          // 가로가 더 긴 이미지 → 세로를 기준으로 자름
          cropSize = imgHeight;
          double left = (imgWidth - cropSize) / 2;
          srcRect = Rect.fromLTWH(left, 0, cropSize, cropSize);
        } else {
          // 세로가 더 긴 이미지 → 가로를 기준으로 자름
          cropSize = imgWidth;
          double top = (imgHeight - cropSize) / 2;
          srcRect = Rect.fromLTWH(0, top, cropSize, cropSize);
        }

        // ✅ 원 안에 가득 차게 그리기 (dstRect)
        Rect dstRect = Rect.fromCircle(
            center: Offset(ball.x, ball.y), radius: ball.radius);
        canvas.drawImageRect(
          ball.image!,
          srcRect, // 크롭된 이미지 영역
          dstRect, // 원 안에 꽉 채우기
          Paint(),
        );

        canvas.restore();
      }

      // ✅ 공 보더 추가 (선택 사항)
      final borderPaint = Paint()
        ..color = Colors.white // 보더 색상
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2; // 보더 두께
      canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
