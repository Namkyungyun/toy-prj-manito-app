import 'dart:math';

import 'package:flutter/material.dart';

class FlowerWidget extends StatefulWidget {
  final double size;
  final VoidCallback onPressed;

  const FlowerWidget({
    super.key,
    required this.onPressed,
    required this.size,
  });

  @override
  State<FlowerWidget> createState() => _FlowerWidgetState();
}

class _FlowerWidgetState extends State<FlowerWidget> {
  double side = 0;
  double center = 0;
  double border = 1;

  @override
  void initState() {
    super.initState();
    side = ((widget.size > 130) ? widget.size / 3 : widget.size / 2);
    center = (widget.size > 130) ? 90 : 50;

    if (widget.size > 150) {
      side = widget.size / 2.5;
      center = widget.size / 1.7;
      border = 4;
      return;
    } else if (widget.size > 130) {
      side = widget.size / 3;
      center = widget.size / 2.2;
      border = 3;
      return;
    } else {
      side = widget.size / 2.2;
      center = widget.size / 1.6;
      border = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(top: 100),
            child: const CurvedBarWidget()),
        for (int i = 0; i < 6; i++)
          Transform(
            transform: Matrix4.identity()
              ..translate(
                  (side - 20) * cos(i * pi / 3), (side - 20) * sin(i * pi / 3)),
            child: Container(
              width: side,
              height: side,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 17, 83), // 내부 색상 (빨간색 계열)
                shape: BoxShape.circle, // 원형 모양
                border: Border.all(
                  color: Colors.black, // 검은색 테두리
                  width: border, // 테두리 두께
                ),
              ),
            ),
          ),
        Container(
          width: center,
          height: center,
          decoration: BoxDecoration(
            color: Colors.amber.shade200,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: border),
          ),
        ),
      ],
    );
  }
}

class CurvedBarWidget extends StatelessWidget {
  const CurvedBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(30, 100), // 크기 조절 가능
      painter: CurvedBarPainter(),
    );
  }
}

class CurvedBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    Paint borderPaint = Paint()
      ..color = Colors.black // 테두리 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // 테두리 두께

    Path path = Path();
    double width = size.width;
    double height = size.height;

    // 시작점
    path.moveTo(0, 0);

    // 위쪽 곡선
    path.quadraticBezierTo(0, height * 0.6, width * 0.2, height * 0.5);

    // 아래쪽 곡선
    path.quadraticBezierTo(width * 0.5, height, 0, height);

    path.close(); // 경로 닫기

    canvas.drawPath(path, paint);

    // 테두리 그리기
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
