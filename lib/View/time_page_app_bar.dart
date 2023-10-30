import 'package:flutter/material.dart';

class TimePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TimePageAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
