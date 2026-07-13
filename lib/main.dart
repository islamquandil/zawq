import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_shell.dart';

void main() {
  runApp(const ProviderScope(child: ZawqApp()));
}

/// Root widget: wires theme + locale (EN/AR with automatic RTL) to state.
class ZawqApp extends ConsumerWidget {
  const ZawqApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'Zawq',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(locale.languageCode == 'ar'),
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeShell(),
    );
  }
}
