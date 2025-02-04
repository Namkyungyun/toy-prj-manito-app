import 'dart:math';

import 'package:flutter/material.dart';

class FlowerWidget extends StatefulWidget {
  final double width;
  final VoidCallback onPressed;

  const FlowerWidget({
    super.key,
    required this.onPressed,
    required this.width,
  });

  @override
  State<FlowerWidget> createState() => _FlowerWidgetState();
}

class _FlowerWidgetState extends State<FlowerWidget> {
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
              ..translate(40 * cos(i * pi / 3), 40 * sin(i * pi / 3)),
            child: Container(
              width:
                  (widget.width > 150) ? widget.width / 3 : widget.width / 2.2,
              height:
                  (widget.width > 150) ? widget.width / 3 : widget.width / 2.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 17, 83), // 내부 색상 (빨간색 계열)
                shape: BoxShape.circle, // 원형 모양
                border: Border.all(
                  color: Colors.black, // 검은색 테두리
                  width: 4.0, // 테두리 두께
                ),
              ),
            ),
          ),
        SizedBox(
          width: (widget.width > 150) ? 90 : 90,
          height: (widget.width > 150) ? 90 : 90,
          child: ElevatedButton(
            onPressed: () => print('꽃 중앙 버튼 눌림'),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(
                side: BorderSide(
                  color: Colors.black, // 검은색 테두리
                  width: 4.0, // 테두리 두께
                ),
              ),
              backgroundColor: Colors.amber.shade200, // 버튼 배경색
            ),
            child: const Text(
              '',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
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
      ..strokeWidth = 5.0; // 테두리 두께

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
