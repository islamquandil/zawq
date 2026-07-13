import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/rating_badge.dart';
import '../../domain/entities/food_list.dart';
import '../restaurant/restaurant_detail_screen.dart';

/// Detail page for a community list or one of the user's own lists.
class ListDetailScreen extends ConsumerWidget {
  const ListDetailScreen({super.key, required this.listId});

  final String listId;

  FoodList? _find(WidgetRef ref) {
    for (final fl in ref.watch(myListsProvider)) {
      if (fl.id == listId) return fl;
    }
    for (final fl in ref.watch(listRepoProvider).communityLists()) {
      if (fl.id == listId) return fl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.l10n;
    final fl = _find(ref);
    if (fl == null) {
      // The list was just deleted; render nothing while popping.
      return const Scaffold(body: SizedBox.shrink());
    }
    final repo = ref.watch(restaurantRepoProvider);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      if (fl.isMine)
                        TextButton.icon(
                          onPressed: () async {
                            final ok = await confirmSheet(
                              context,
                              title: l.confirmDeleteList,
                              confirmLabel: l.deleteL,
                              cancelLabel: l.cancel,
                              destructive: true,
                            );
                            if (ok && context.mounted) {
                              ref
                                  .read(myListsProvider.notifier)
                                  .delete(fl.id);
                              Navigator.pop(context);
                              showSnack(context, l.toastListDeleted);
                            }
                          },
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18, color: Z.error),
                          label: Text(l.deleteList,
                              style: const TextStyle(color: Z.error)),
                        )
                      else
                        FilledButton.tonalIcon(
                          onPressed: () {
                            ref
                                .read(myListsProvider.notifier)
                                .saveCommunity(fl);
                            showSnack(context, l.toastListSaved);
                          },
                          icon: const Icon(Icons.bookmark_add_outlined,
                              size: 18),
                          label: Text(l.listSaveBtn),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            shape: const StadiumBorder(),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fl.title,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.15)),
                      const SizedBox(height: 4),
                      Text(l.byLine(fl.author, fl.restaurantIds.length),
                          style: const TextStyle(
                              fontSize: 13, color: Z.onSurfaceVariant)),
                      if (fl.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(fl.description,
                            style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.4,
                                color: Z.onSurfaceVariant)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: fl.restaurantIds.isEmpty
                      ? Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(l.noRestInList,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13.5,
                                    height: 1.5,
                                    color: Z.onSurfaceVariant)),
                          ),
                        )
                      : ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          itemCount: fl.restaurantIds.length,
                          separatorBuilder: (_, __) => const Divider(
                              height: 1, color: Z.outlineVariant),
                          itemBuilder: (context, i) {
                            final r = repo.byId(fl.restaurantIds[i]);
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              leading: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Color(r.heroColor),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              title: Text(r.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14.5)),
                              subtitle: Text(
                                  '${r.category} · ${l.far}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Z.onSurfaceVariant)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBadge(value: r.rating),
                                  if (fl.isMine)
                                    IconButton(
                                      icon: const Icon(
                                          Icons.close_rounded,
                                          size: 20,
                                          color: Z.onSurfaceVariant),
                                      onPressed: () {
                                        ref
                                            .read(
                                                myListsProvider.notifier)
                                            .removeRestaurant(
                                                fl.id, r.id);
                                        showSnack(
                                            context, l.toastItemRemoved);
                                      },
                                    ),
                                ],
                              ),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        RestaurantDetailScreen(id: r.id)),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
