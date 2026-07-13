import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_sheet.dart';

/// Opens the Top 8 picker (candidates = reviewed ∪ saved places).
Future<void> showTop8Editor(BuildContext context, WidgetRef ref) {
  return showAppSheet(
    context,
    builder: (_) => const _Top8EditorSheet(),
  );
}

class _Top8EditorSheet extends ConsumerWidget {
  const _Top8EditorSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.l10n;
    final repo = ref.watch(restaurantRepoProvider);
    final reviews = ref.watch(reviewsProvider);
    final saved = ref.watch(savedProvider);
    final top8 = ref.watch(top8Provider);

    final candidates = <int>{...reviews.keys, ...saved}.toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.top8Edit,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(l.top8Hint,
              style: const TextStyle(
                  fontSize: 12.5, color: Z.onSurfaceVariant)),
          const SizedBox(height: 14),
          if (candidates.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(l.top8Empty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: Z.onSurfaceVariant)),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: candidates.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Z.outlineVariant),
                itemBuilder: (context, i) {
                  final r = repo.byId(candidates[i]);
                  final selected = top8.contains(r.id);
                  final slot = top8.indexOf(r.id);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 46,
                      height: 46,
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
                    trailing: selected
                        ? CircleAvatar(
                            radius: 13,
                            backgroundColor: Z.primary,
                            child: Text('${slot + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800)),
                          )
                        : const Icon(Icons.circle_outlined,
                            size: 22, color: Z.outlineVariant),
                    onTap: () =>
                        ref.read(top8Provider.notifier).toggle(r.id),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.done),
          ),
        ],
      ),
    );
  }
}
