import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/seg_tabs.dart';
import '../../domain/entities/food_list.dart';
import 'create_list_sheet.dart';
import 'list_detail_screen.dart';

/// Lists tab: community lists + the user's own lists.
class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  int _tab = 0;

  void _open(FoodList list) => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ListDetailScreen(listId: list.id)));

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final community = ref.watch(listRepoProvider).communityLists();
    final mine = ref.watch(myListsProvider);
    final showing = _tab == 0 ? community : mine;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l.navLists,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800)),
                const Spacer(),
                Material(
                  color: Z.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => showCreateListSheet(context, ref),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child:
                          Icon(Icons.add_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SegTabs(
              labels: [l.tabAll, l.tabMine],
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _tab == 1 && mine.isEmpty
                  ? _EmptyLists(l: l)
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      itemCount: showing.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: Z.outlineVariant),
                      itemBuilder: (context, i) {
                        final fl = showing[i];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 6),
                          leading: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Color(fl.colorValue),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.restaurant_menu_rounded,
                                color: Colors.white70),
                          ),
                          title: Text(fl.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800)),
                          subtitle: Text(
                            l.byLine(fl.author, fl.restaurantIds.length),
                            style: const TextStyle(
                                fontSize: 12.5, color: Z.onSurfaceVariant),
                          ),
                          trailing: Icon(
                            Directionality.of(context) == TextDirection.rtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            color: Z.onSurfaceVariant,
                          ),
                          onTap: () => _open(fl),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLists extends StatelessWidget {
  const _EmptyLists({required this.l});

  final L10n l;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                  color: Z.surfaceHigh, shape: BoxShape.circle),
              child: const Icon(Icons.checklist_rounded,
                  size: 32, color: Z.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Text(l.noListsTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(l.noListsBody,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Z.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
