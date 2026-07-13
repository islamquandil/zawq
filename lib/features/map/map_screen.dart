import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/filters.dart';
import '../../domain/entities/restaurant.dart';
import '../restaurant/restaurant_detail_screen.dart';
import 'filters_sheet.dart';
import 'map_canvas.dart';

/// Discovery map: pins, search, quick chips, and the filter sheet.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  int? _selectedId;
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: ref.read(mapQueryProvider));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openDetail(Restaurant r) => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RestaurantDetailScreen(id: r.id)));

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final results = ref.watch(filteredRestaurantsProvider);
    final hitlistOnly = ref.watch(hitlistOnlyProvider);
    final who = ref.watch(whoProvider);
    final where = ref.watch(whereProvider);
    final filters = ref.watch(mapFiltersProvider);

    final Restaurant? selected = results.isEmpty
        ? null
        : results.firstWhere((r) => r.id == _selectedId,
            orElse: () => results.first);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: MapCanvas(
                  restaurants: results,
                  selectedId: selected?.id,
                  onPinTap: (r) => setState(() => _selectedId = r.id),
                ),
              ),
              // Locate: recenters selection on the top result.
              PositionedDirectional(
                top: MediaQuery.of(context).padding.top + 8,
                end: 12,
                child: _RoundButton(
                  icon: Icons.near_me_outlined,
                  onTap: () => setState(() => _selectedId = null),
                ),
              ),
              if (results.isEmpty)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Color(0x22000000), blurRadius: 10),
                      ],
                    ),
                    child: Text(l.noResults,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              if (selected != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  height: 108,
                  child: _CardCarousel(
                    results: results,
                    selected: selected,
                    l10nClosed: l.closedL,
                    l10nOpen: l.openL,
                    onOpen: _openDetail,
                  ),
                ),
            ],
          ),
        ),
        // Control sheet under the map.
        Container(
          color: Z.surface,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: Column(
            children: [
              SizedBox(
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _RoundButton(
                      icon: Icons.tune_rounded,
                      badge: filters.isActive,
                      onTap: () => showFiltersSheet(context, ref),
                    ),
                    const SizedBox(width: 8),
                    _QuickChip(
                      selected: hitlistOnly,
                      icon: Icons.bookmark_rounded,
                      label: l.hitlist,
                      onTap: () => ref
                          .read(hitlistOnlyProvider.notifier)
                          .state = !hitlistOnly,
                    ),
                    const SizedBox(width: 8),
                    _MenuChip<WhoFilter>(
                      icon: Icons.person_search_outlined,
                      label: switch (who) {
                        WhoFilter.anyone => l.whoAnyone,
                        WhoFilter.friends => l.whoFriends,
                        WhoFilter.me => l.whoMe,
                      },
                      values: WhoFilter.values,
                      labelOf: (v) => switch (v) {
                        WhoFilter.anyone => l.whoAnyone,
                        WhoFilter.friends => l.whoFriends,
                        WhoFilter.me => l.whoMe,
                      },
                      onSelected: (v) =>
                          ref.read(whoProvider.notifier).state = v,
                    ),
                    const SizedBox(width: 8),
                    _MenuChip<WhereFilter>(
                      icon: Icons.place_outlined,
                      label: where == WhereFilter.nearMe
                          ? l.whereNear
                          : l.whereEverywhere,
                      values: WhereFilter.values,
                      labelOf: (v) => v == WhereFilter.nearMe
                          ? l.whereNear
                          : l.whereEverywhere,
                      onSelected: (v) =>
                          ref.read(whereProvider.notifier).state = v,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _search,
                onChanged: (v) =>
                    ref.read(mapQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: l.searchRest,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _search.clear();
                            ref.read(mapQueryProvider.notifier).state = '';
                            setState(() {});
                          },
                        ),
                  filled: true,
                  fillColor: Z.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardCarousel extends StatelessWidget {
  const _CardCarousel({
    required this.results,
    required this.selected,
    required this.onOpen,
    required this.l10nClosed,
    required this.l10nOpen,
  });

  final List<Restaurant> results;
  final Restaurant selected;
  final ValueChanged<Restaurant> onOpen;
  final String l10nClosed;
  final String l10nOpen;

  @override
  Widget build(BuildContext context) {
    final ordered = [
      selected,
      ...results.where((r) => r.id != selected.id).take(2),
    ];
    final width = MediaQuery.of(context).size.width;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: ordered.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, i) {
        final r = ordered[i];
        return GestureDetector(
          onTap: () => onOpen(r),
          child: Container(
            width: width * 0.82,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 12,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Color(r.heroColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(r.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, height: 1.15)),
                      const SizedBox(height: 3),
                      Text('${r.category} · ${r.priceLabel}',
                          style: const TextStyle(
                              fontSize: 12.5, color: Z.onSurfaceVariant)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Z.outlineVariant),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          r.isClosed ? l10nClosed : l10nOpen,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: r.isClosed
                                ? Z.onSurfaceVariant
                                : Z.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap, this.badge = false});

  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 20, color: Z.onSurface),
              if (badge)
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Z.tertiary, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      avatar: Icon(icon,
          size: 16, color: selected ? Z.primary : Z.onSurfaceVariant),
      label: Text(label),
      showCheckmark: false,
      shape: const StadiumBorder(),
      side: BorderSide(
          color: selected ? Z.secondaryContainer : Z.outlineVariant),
      selectedColor: Z.secondaryContainer,
      backgroundColor: Colors.white,
    );
  }
}

class _MenuChip<T> extends StatelessWidget {
  const _MenuChip({
    required this.icon,
    required this.label,
    required this.values,
    required this.labelOf,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, _) => ActionChip(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        avatar: Icon(icon, size: 16, color: Z.onSurfaceVariant),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const Icon(Icons.arrow_drop_down_rounded, size: 18),
          ],
        ),
        shape: const StadiumBorder(),
        side: const BorderSide(color: Z.outlineVariant),
        backgroundColor: Colors.white,
      ),
      menuChildren: [
        for (final v in values)
          MenuItemButton(
            onPressed: () => onSelected(v),
            child: Text(labelOf(v)),
          ),
      ],
    );
  }
}
