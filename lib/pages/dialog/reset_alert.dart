import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetAlert extends StatelessWidget {
  final VoidCallback onReset;
  const ResetAlert({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: const Text(
        'Reset',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        '모든 기기 저장 데이터를\n초기화 하시겠습니까?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              _buildButton('No', onDone: context.pop),
              const SizedBox(width: 10),
              _buildButton('Yes', onDone: () {
                onReset();
                context.pop();
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    String label, {
    required VoidCallback onDone,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 버튼 배경색
          borderRadius: BorderRadius.circular(12), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상
              blurRadius: 15, // 그림자 퍼짐 정도
              spreadRadius: 1, // 그림자 확산 정도
              offset: Offset(0, 5), // 그림자 위치 (x, y)
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onDone,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 배경색
            shadowColor: Colors.transparent, // ElevatedButton의 기본 그림자는 제거
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // 버튼의 둥근 모서리 값
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
