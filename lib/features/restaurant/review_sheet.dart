import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/section_label.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/review.dart';

/// Opens the "leave a review" flow for [restaurant].
Future<void> showReviewSheet(
  BuildContext context,
  WidgetRef ref,
  Restaurant restaurant,
) {
  return showAppSheet(
    context,
    expand: true,
    builder: (_) => _ReviewSheet(restaurant: restaurant),
  );
}

class _ReviewSheet extends ConsumerStatefulWidget {
  const _ReviewSheet({required this.restaurant});

  final Restaurant restaurant;

  @override
  ConsumerState<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<_ReviewSheet> {
  late double _rating;
  late bool _showNumber;
  late Set<String> _dishes;
  late int _photos;
  final _dishCtrl = TextEditingController();
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(reviewsProvider)[widget.restaurant.id];
    _rating = existing?.rating ?? 7.0;
    _showNumber = true;
    _dishes = {...?existing?.dishes};
    _photos = existing?.photoCount ?? 0;
    _descCtrl = TextEditingController(text: existing?.description ?? '');
  }

  @override
  void dispose() {
    _dishCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _step(double delta) => setState(
      () => _rating = (_rating + delta).clamp(0.0, 10.0));

  void _addCustomDish() {
    final v = _dishCtrl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      _dishes.add(v);
      _dishCtrl.clear();
    });
  }

  void _submit() {
    final l = ref.read(l10nProvider);
    final rounded = (_rating * 10).round() / 10;
    ref.read(reviewsProvider.notifier).submit(
          widget.restaurant.id,
          Review(
            rating: rounded,
            dishes: _dishes.toList(),
            description: _descCtrl.text.trim(),
            photoCount: _photos,
          ),
        );
    Navigator.pop(context);
    showSnack(context, l.toastReview(rounded.toStringAsFixed(1)));
  }

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final r = widget.restaurant;
    final color = Z.rating(_rating);
    final query = _dishCtrl.text.trim().toLowerCase();
    final suggestions = [
      for (final d in r.dishes)
        if (query.isEmpty || d.toLowerCase().contains(query)) d,
      // Custom dishes the user added that aren't on the seed menu.
      for (final d in _dishes)
        if (!r.dishes.contains(d)) d,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text(
          l.reviewQ(r.name),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 24),

        // Floating score bubble that tracks the slider thumb.
        LayoutBuilder(
          builder: (context, box) {
            const thumbInset = 24.0;
            final travel = box.maxWidth - thumbInset * 2;
            final frac = _rating / 10;
            return SizedBox(
              height: 88,
              child: Stack(
                children: [
                  PositionedDirectional(
                    start: thumbInset + travel * frac - 27,
                    top: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: 54,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color,
                        thumbColor: color,
                        trackHeight: 6,
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 18),
                      ),
                      child: Slider(
                        min: 0,
                        max: 10,
                        divisions: 100,
                        value: _rating,
                        onChanged: (v) => setState(() => _rating = v),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Stepper(icon: Icons.remove, onTap: () => _step(-0.1)),
            Row(
              children: [
                Text(l.showNumber,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: Z.onSurfaceVariant)),
                Switch(
                  value: _showNumber,
                  onChanged: (v) => setState(() => _showNumber = v),
                ),
              ],
            ),
            _Stepper(icon: Icons.add, onTap: () => _step(0.1)),
          ],
        ),
        const SizedBox(height: 20),

        SectionLabel(l.addPhotos),
        const SizedBox(height: 10),
        SizedBox(
          height: 84,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _AddTile(onTap: () => setState(() => _photos++)),
              for (var i = 0; i < _photos; i++)
                _PhotoStub(
                  index: i,
                  onRemove: () => setState(() => _photos--),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        SectionLabel(l.whatOrder),
        const SizedBox(height: 10),
        TextField(
          controller: _dishCtrl,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _addCustomDish(),
          decoration: InputDecoration(
            hintText: l.searchDish,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _dishCtrl.text.trim().isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addCustomDish,
                  ),
            filled: true,
            fillColor: Z.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final d in suggestions)
              FilterChip(
                label: Text(d),
                selected: _dishes.contains(d),
                onSelected: (v) => setState(
                    () => v ? _dishes.add(d) : _dishes.remove(d)),
                selectedColor: Z.primaryContainer,
                checkmarkColor: Z.onPrimaryContainer,
              ),
          ],
        ),
        const SizedBox(height: 20),

        SectionLabel(l.leaveDesc),
        const SizedBox(height: 10),
        TextField(
          controller: _descCtrl,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: l.descPh,
            filled: true,
            fillColor: Z.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(l.submit,
              style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Z.surfaceHigh,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20, color: Z.onSurface),
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: Material(
        color: Z.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: 84,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Z.outlineVariant),
            ),
            child: const Icon(Icons.add_a_photo_outlined,
                color: Z.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _PhotoStub extends StatelessWidget {
  const _PhotoStub({required this.index, required this.onRemove});

  final int index;
  final VoidCallback onRemove;

  static const _swatches = [
    Color(0xFFD8A048),
    Color(0xFF8B4513),
    Color(0xFFC46B3A),
    Color(0xFF5D7052),
    Color(0xFF1F2733),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _swatches[index % _swatches.length];
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: Stack(
        children: [
          Container(
            width: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.6)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.photo, color: Colors.white70),
            ),
          ),
          PositionedDirectional(
            top: 4,
            end: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
