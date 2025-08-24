import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({super.key, this.child, this.backgroundColor, this.maxRadius});

  final Widget? child;
  final Color? backgroundColor;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: maxRadius,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
      child: child,
    );
  }
}
