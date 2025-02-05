import 'package:camellia_manito/pages/widgets/flower_widget.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatefulWidget {
  final int index;
  final double size;

  const UserCardWidget({
    super.key,
    required this.index,
    required this.size,
  });

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
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
              size: widget.size,
              onPressed: () {},
            ),
            Image.asset(
              'assets/images/grandma${widget.index}.png',
              width: widget.size,
              height: widget.size,
            ),
          ],
        ),
      ),
    );
  }
}
