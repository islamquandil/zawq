import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/restaurant.dart';

/// Stylized street-map canvas with tappable rating pins.
class MapCanvas extends StatelessWidget {
  const MapCanvas({
    super.key,
    required this.restaurants,
    required this.selectedId,
    required this.onPinTap,
  });

  final List<Restaurant> restaurants;
  final int? selectedId;
  final ValueChanged<Restaurant> onPinTap;

  static const _districts = [
    ('WESTLAKE', 0.14, 0.16), ('BROADMOOR', 0.44, 0.22),
    ('ST. FRANCIS', 0.30, 0.40), ('SERRAMONTE', 0.50, 0.58),
    ('FAIRMONT', 0.16, 0.62), ('COLMA', 0.80, 0.44),
    ('WESTVIEW', 0.26, 0.86), ('SERRA HIGHLANDS', 0.76, 0.82),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final h = box.maxHeight;
        return Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _StreetPainter())),
            for (final (name, x, y) in _districts)
              Positioned(
                left: x * w - 60,
                top: y * h - 8,
                width: 120,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9B978A),
                  ),
                ),
              ),
            for (final r in restaurants)
              Positioned(
                left: r.mapX * w - 26,
                top: r.mapY * h - 44,
                child: _RatingPin(
                  restaurant: r,
                  selected: r.id == selectedId,
                  onTap: () => onPinTap(r),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RatingPin extends StatelessWidget {
  const _RatingPin({
    required this.restaurant,
    required this.selected,
    required this.onTap,
  });

  final Restaurant restaurant;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Z.rating(restaurant.rating);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 160),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? Z.primary : Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 6,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Text(
                restaurant.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: selected ? Colors.white : color,
                ),
              ),
            ),
            Transform.rotate(
              angle: 0.785,
              child: Container(
                width: 9,
                height: 9,
                transform: Matrix4.translationValues(0, -4, 0),
                color: selected ? Z.primary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFEDEAE0);
    canvas.drawRect(Offset.zero & size, bg);

    void street(Offset a, Offset b, double width, Color color) {
      final p = Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(a.dx * size.width, a.dy * size.height),
        Offset(b.dx * size.width, b.dy * size.height),
        p,
      );
    }

    const minor = Color(0xFFD8D4C6);
    const major = Color(0xFFCFCBBC);
    const faint = Color(0xFFE2DFD3);

    street(const Offset(0, 0.20), const Offset(1, 0.08), 5, minor);
    street(const Offset(0, 0.45), const Offset(1, 0.30), 8, major);
    street(const Offset(0, 0.78), const Offset(1, 0.62), 5, minor);
    street(const Offset(0.18, 0), const Offset(0.30, 1), 7, major);
    street(const Offset(0.52, 0), const Offset(0.60, 1), 5, minor);
    street(const Offset(0.80, 0), const Offset(0.74, 1), 7, major);
    street(const Offset(0.36, 0), const Offset(0.42, 1), 3, faint);
    street(const Offset(0, 0.60), const Offset(1, 0.46), 3, faint);

    final park = Paint()..color = const Color(0xFFBCD9AE);
    RRect rr(double x, double y, double w, double h) => RRect.fromRectAndRadius(
          Rect.fromLTWH(
              x * size.width, y * size.height, w * size.width, h * size.height),
          const Radius.circular(8),
        );
    canvas.drawRRect(rr(0.06, 0.06, 0.10, 0.08), park);
    canvas.drawRRect(rr(0.62, 0.70, 0.12, 0.09), park);
    canvas.drawRRect(rr(0.40, 0.14, 0.08, 0.06), park);

    final water = Paint()..color = const Color(0xFFBFD9EA);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.10 * size.width, 0)
      ..lineTo(0.04 * size.width, 0.12 * size.height)
      ..lineTo(0, 0.14 * size.height)
      ..close();
    canvas.drawPath(path, water);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
