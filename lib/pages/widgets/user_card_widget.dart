import 'package:camellia_manito/pages/widgets/flower_widget.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatefulWidget {
  final int index;
  final dynamic user;
  final double size;

  const UserCardWidget({
    super.key,
    required this.index,
    required this.user,
    required this.size,
  });

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  String? _userImage = null;
  String _grandmaImage = 'assets/images/grandma10.png';

  @override
  void initState() {
    super.initState();

    _userImage = (widget.user == null) ? null : widget.user["image"];
    _grandmaImage = (widget.user == null)
        ? _grandmaImage
        : 'assets/images/${widget.user['grandma']}';
  }

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
              image: _userImage,
              onPressed: () {},
            ),
            Image.asset(
              _grandmaImage,
              width: widget.size,
              height: widget.size,
            ),
          ],
        ),
      ),
    );
  }
}
