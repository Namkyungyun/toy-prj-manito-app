import 'dart:convert';

import 'package:flutter/material.dart';

class EnrollProfileWidget extends StatelessWidget {
  final String? imageData;
  final double size;
  const EnrollProfileWidget({
    super.key,
    this.imageData,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (imageData != null) {
      return CircleAvatar(
        radius: size,
        foregroundImage: MemoryImage(base64Decode(imageData!)),
        backgroundColor: Colors.white.withOpacity(0.5),
      );
    } else {
      return CircleAvatar(
        radius: size,
        backgroundColor: Colors.white.withOpacity(0.5),
        child: Icon(
          Icons.camera_alt,
          size: size + 20,
          color: Colors.white,
        ),
      );
    }
  }
}
