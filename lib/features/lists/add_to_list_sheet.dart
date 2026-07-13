import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';
import 'create_list_sheet.dart';

/// Opens the "add restaurant to a list" picker for [restaurantId].
Future<void> showAddToListSheet(
  BuildContext context,
  WidgetRef ref,
  int restaurantId,
) {
  return showAppSheet(
    context,
    builder: (_) => _AddToListSheet(restaurantId: restaurantId),
  );
}

class _AddToListSheet extends ConsumerWidget {
  const _AddToListSheet({required this.restaurantId});

  final int restaurantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.l10n;
    final lists = ref.watch(myListsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.addToAList,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          if (lists.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(l.noListsYet,
                  style: const TextStyle(
                      fontSize: 13.5, color: Z.onSurfaceVariant)),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: lists.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Z.outlineVariant),
                itemBuilder: (context, i) {
                  final fl = lists[i];
                  final already = fl.restaurantIds.contains(restaurantId);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Color(fl.colorValue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.restaurant_menu_rounded,
                          color: Colors.white70, size: 20),
                    ),
                    title: Text(fl.title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(
                        l.byLine(fl.author, fl.restaurantIds.length),
                        style: const TextStyle(fontSize: 12)),
                    trailing: already
                        ? const Icon(Icons.check_circle_rounded,
                            color: Z.primary)
                        : const Icon(Icons.add_circle_outline_rounded,
                            color: Z.onSurfaceVariant),
                    onTap: () {
                      if (!already) {
                        ref
                            .read(myListsProvider.notifier)
                            .addRestaurant(fl.id, restaurantId);
                      }
                      Navigator.pop(context);
                      showSnack(context, l.toastAdded);
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              final id = await showCreateListSheet(context, ref);
              if (id != null && context.mounted) {
                ref
                    .read(myListsProvider.notifier)
                    .addRestaurant(id, restaurantId);
                showSnack(context, l.toastAdded);
              }
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(l.newList),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
