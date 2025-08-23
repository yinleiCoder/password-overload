import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({super.key, this.child, this.backgroundColor});

  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
      child: child,
    );
  }
}
