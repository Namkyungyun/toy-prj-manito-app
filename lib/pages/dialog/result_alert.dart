import 'package:camellia_manito/pages/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';

class ResultAlert extends StatelessWidget {
  final String name;
  final String image;
  const ResultAlert({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: const Text(
        '나야.. 너의 마.니.또',
        // style: GoogleFonts.nanumPenScript(),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color.fromARGB(255, 102, 100, 100),
        ),
      ),
      content: SizedBox(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UserInfoWidget(
              name: ' ❤️ $name ❤️ ',
              imagePath: image,
              size: 120,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '두번 연속 탭을 해 화면을 닫아주세요!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
