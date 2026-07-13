import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Circular avatar: colored disc with optional initials, falling back to a
/// person glyph when no color/initials are provided.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    this.color,
    this.initials,
    this.size = 56,
  });

  final Color? color;
  final String? initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Z.surfaceHigh;
    final showInitials = initials != null && initials!.isNotEmpty;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: showInitials
          ? Text(
              initials!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size * 0.36,
              ),
            )
          : Icon(Icons.person_rounded,
              size: size * 0.55, color: Colors.white.withOpacity(0.85)),
    );
  }
}
