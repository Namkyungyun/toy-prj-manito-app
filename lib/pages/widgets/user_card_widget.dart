import 'package:camellia_manito/pages/widgets/flower_widget.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatefulWidget {
  final int index;
  final double width;
  final double height;

  const UserCardWidget({
    super.key,
    required this.index,
    required this.width,
    required this.height,
  });

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlowerWidget(
              width: widget.width,
              onPressed: () {},
            ),
            Image.asset(
              'assets/images/grandma${widget.index}.png',
              width: widget.width,
              height: widget.width,
            ),
          ],
        ),
      ),
    );
  }
}
