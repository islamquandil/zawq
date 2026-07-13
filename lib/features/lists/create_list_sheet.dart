import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';

/// Opens the create-list form; resolves with the new list id, or null.
Future<String?> showCreateListSheet(BuildContext context, WidgetRef ref) {
  return showAppSheet<String>(
    context,
    builder: (_) => const _CreateListSheet(),
  );
}

class _CreateListSheet extends ConsumerStatefulWidget {
  const _CreateListSheet();

  @override
  ConsumerState<_CreateListSheet> createState() => _CreateListSheetState();
}

class _CreateListSheetState extends ConsumerState<_CreateListSheet> {
  final _name = TextEditingController();
  final _desc = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _create() {
    final l = ref.read(l10nProvider);
    final title = _name.text.trim();
    if (title.isEmpty) return;
    final id = ref
        .read(myListsProvider.notifier)
        .create(title, _desc.text.trim());
    Navigator.pop(context, id);
    showSnack(context, l.toastList(title));
  }

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final canCreate = _name.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.createList,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: l.listName,
              filled: true,
              fillColor: Z.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _desc,
            minLines: 2,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l.listDesc,
              filled: true,
              fillColor: Z.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: canCreate ? _create : null,
            child: Text(l.createList),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
        ],
      ),
    );
  }
}
