import 'package:camellia_manito/pages/widgets/cached_profile_widget.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatefulWidget {
  final String imagePath;
  final String name;
  final double? size;

  const UserInfoWidget({
    super.key,
    required this.imagePath,
    required this.name,
    this.size,
  });

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.size ?? 90,
          height: widget.size ?? 90,
          decoration: BoxDecoration(
            // color: Colors.amber.shade200,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              width: 1,
              color: Colors.grey.shade200,
            ),
          ),
          child: CachedProfileWidget(
            size: 60,
            imagePath: widget.imagePath,
          ),
        ),
        SizedBox(
          child: Text(
            widget.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (widget.size == null) ? 18 : 22,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
