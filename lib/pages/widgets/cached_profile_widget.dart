import 'dart:io';

import 'package:flutter/material.dart';

class CachedProfileWidget extends StatelessWidget {
  final String imagePath;
  final double size;

  const CachedProfileWidget({
    super.key,
    required this.imagePath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.file(
        File(imagePath),
        width: size, // 원하는 크기로 조정
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
