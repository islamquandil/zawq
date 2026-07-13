import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Standard modal bottom sheet with grab handle and safe padding.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool expand = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: expand ? 0.94 : null,
        child: Column(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Z.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (expand) Expanded(child: builder(ctx)) else Flexible(child: builder(ctx)),
          ],
        ),
      ),
    ),
  );
}

/// Simple confirmation sheet; resolves true when confirmed.
Future<bool> confirmSheet(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showAppSheet<bool>(
    context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(backgroundColor: Z.error)
                : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelLabel),
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}
