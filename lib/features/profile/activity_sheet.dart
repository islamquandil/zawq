import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/rating_badge.dart';
import '../restaurant/restaurant_detail_screen.dart';

/// Which activity collection to display.
enum ActivityKind { visited, saved }

/// Opens the visited/saved places sheet from the profile stats.
Future<void> showActivitySheet(
  BuildContext context,
  WidgetRef ref,
  ActivityKind kind,
) {
  return showAppSheet(
    context,
    builder: (_) => _ActivitySheet(kind: kind),
  );
}

class _ActivitySheet extends ConsumerWidget {
  const _ActivitySheet({required this.kind});

  final ActivityKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.l10n;
    final repo = ref.watch(restaurantRepoProvider);
    final reviews = ref.watch(reviewsProvider);
    final saved = ref.watch(savedProvider);

    final visited = kind == ActivityKind.visited;
    final ids = visited ? reviews.keys.toList() : saved.toList();
    final title = visited ? l.visitedSheet : l.savedSheet;
    final empty = visited ? l.emptyVisited : l.emptySaved;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          if (ids.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(empty,
                    style: const TextStyle(
                        fontSize: 13.5, color: Z.onSurfaceVariant)),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: ids.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Z.outlineVariant),
                itemBuilder: (context, i) {
                  final r = repo.byId(ids[i]);
                  final score =
                      visited ? reviews[r.id]!.rating : r.rating;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(r.heroColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    title: Text(r.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: Text(r.category,
                        style: const TextStyle(
                            fontSize: 12, color: Z.onSurfaceVariant)),
                    trailing: RatingBadge(value: score),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              RestaurantDetailScreen(id: r.id)));
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
