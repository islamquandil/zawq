import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';

/// Opens the avatar swatch picker.
Future<void> showAvatarPicker(BuildContext context, WidgetRef ref) {
  return showAppSheet(
    context,
    builder: (_) => const _AvatarPickerSheet(),
  );
}

class _AvatarPickerSheet extends ConsumerWidget {
  const _AvatarPickerSheet();

  static const _swatches = [
    0xFF2E6B4F, 0xFF8A5100, 0xFF5D7052,
    0xFF8C6A5D, 0xFF1F2733, 0xFFB8B8D1,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.l10n;
    final current = ref.watch(profileProvider).avatarColorValue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.avatarH,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final value in _swatches)
                GestureDetector(
                  onTap: () {
                    ref.read(profileProvider.notifier).setAvatar(value);
                    Navigator.pop(context);
                    showSnack(context, l.toastAvatar);
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Color(value),
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                        color: current == value
                            ? Z.tertiary
                            : Colors.transparent,
                      ),
                    ),
                    child: current == value
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
