import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/section_label.dart';
import '../../data/datasources/seed_data.dart';
import '../../domain/entities/filters.dart';

/// Opens the map filter sheet; applies the draft back to providers.
Future<void> showFiltersSheet(BuildContext context, WidgetRef ref) {
  return showAppSheet(
    context,
    expand: true,
    builder: (_) => _FiltersSheet(
      initial: ref.read(mapFiltersProvider),
      onApply: (f) => ref.read(mapFiltersProvider.notifier).state = f,
    ),
  );
}

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet({required this.initial, required this.onApply});

  final MapFilters initial;
  final ValueChanged<MapFilters> onApply;

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  late Set<String> _cuisines;
  late Set<String> _michelin;
  late bool _friendsOnly;
  String _cuisineQuery = '';

  @override
  void initState() {
    super.initState();
    _cuisines = {...widget.initial.cuisines};
    _michelin = {...widget.initial.michelin};
    _friendsOnly = widget.initial.friendsOnly;
  }

  bool get _dirty =>
      _cuisines.isNotEmpty || _michelin.isNotEmpty || _friendsOnly;

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final visibleCuisines = SeedData.cuisines
        .where((c) =>
            _cuisineQuery.isEmpty ||
            c.$2.toLowerCase().contains(_cuisineQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
          child: Row(
            children: [
              Text(l.filters,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800)),
              const Spacer(),
              if (_dirty)
                TextButton(
                  onPressed: () => setState(() {
                    _cuisines = {};
                    _michelin = {};
                    _friendsOnly = false;
                  }),
                  child: Text(l.clearAll,
                      style: const TextStyle(color: Z.tertiary)),
                ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              SectionLabel(l.location),
              TextField(
                onChanged: (v) => setState(() => _cuisineQuery = v),
                decoration: InputDecoration(
                  hintText: l.searchCuisine,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: Z.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              SectionLabel(l.cuisineL),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (emoji, label) in visibleCuisines)
                    FilterChip(
                      selected: _cuisines.contains(label),
                      onSelected: (_) => setState(() =>
                          _cuisines.contains(label)
                              ? _cuisines.remove(label)
                              : _cuisines.add(label)),
                      avatar: Text(emoji, style: const TextStyle(fontSize: 14)),
                      label: Text(label),
                      showCheckmark: false,
                      shape: const StadiumBorder(),
                      selectedColor: Z.secondaryContainer,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: _cuisines.contains(label)
                              ? Z.secondaryContainer
                              : Z.outlineVariant),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SectionLabel(l.otherFilters),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.friendsRec,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                value: _friendsOnly,
                onChanged: (v) => setState(() => _friendsOnly = v),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (key, stars) in SeedData.michelinStars)
                    _michelinChip(key, '${'❁' * stars} ', _starLabel(stars)),
                  for (final (key, glyph, label) in SeedData.michelinGuides)
                    _michelinChip(key, '$glyph ', label,
                        green: key == 'green'),
                ],
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () {
                  widget.onApply(MapFilters(
                    cuisines: _cuisines,
                    friendsOnly: _friendsOnly,
                    michelin: _michelin,
                  ));
                  Navigator.pop(context);
                },
                child: Text(l.apply),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _starLabel(int n) => switch (n) {
        1 => 'One Star',
        2 => 'Two Stars',
        _ => 'Three Stars',
      };

  Widget _michelinChip(String key, String glyph, String label,
      {bool green = false}) {
    final selected = _michelin.contains(key);
    return FilterChip(
      selected: selected,
      onSelected: (_) => setState(
          () => selected ? _michelin.remove(key) : _michelin.add(key)),
      avatar: Text(glyph,
          style: TextStyle(
              fontSize: 13,
              color: green ? const Color(0xFF2E7D32) : const Color(0xFFC4302B))),
      label: Text(label),
      showCheckmark: false,
      shape: const StadiumBorder(),
      selectedColor: Z.secondaryContainer,
      backgroundColor: Colors.white,
      side: BorderSide(
          color: selected ? Z.secondaryContainer : Z.outlineVariant),
    );
  }
}
