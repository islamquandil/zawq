import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../lists/lists_screen.dart';
import '../map/map_screen.dart';
import '../people/people_screen.dart';
import '../profile/profile_screen.dart';

/// Root shell: splash overlay, four tabs in an [IndexedStack], the M3
/// navigation bar, and the floating EN/AR toggle pill.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _tab = 0;
  bool _splashDone = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) setState(() => _splashDone = true);
    });
  }

  void _toggleLang() {
    final current = ref.read(localeProvider);
    ref.read(localeProvider.notifier).state =
        current.languageCode == 'en' ? const Locale('ar') : const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final isAr = l.ar;

    return Scaffold(
      body: Stack(
        children: [
          // Tab content, constrained for tablets.
          Positioned.fill(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: IndexedStack(
                  index: _tab,
                  children: const [
                    MapScreen(),
                    PeopleScreen(),
                    ListsScreen(),
                    ProfileScreen(),
                  ],
                ),
              ),
            ),
          ),
          // Language toggle pill.
          Positioned(
            top: MediaQuery.of(context).padding.top + 6,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: Z.onSurface,
                borderRadius: BorderRadius.circular(999),
                elevation: 3,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: _toggleLang,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      isAr ? 'English' : 'العربية',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Splash overlay.
          IgnorePointer(
            ignoring: _splashDone,
            child: AnimatedOpacity(
              opacity: _splashDone ? 0 : 1,
              duration: const Duration(milliseconds: 450),
              child: const _Splash(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map),
              label: l.navMap),
          NavigationDestination(
              icon: const Icon(Icons.group_outlined),
              selectedIcon: const Icon(Icons.group),
              label: l.navPeople),
          NavigationDestination(
              icon: const Icon(Icons.checklist_rounded),
              selectedIcon: const Icon(Icons.checklist_rtl_rounded),
              label: l.navLists),
          NavigationDestination(
              icon: const Icon(Icons.account_circle_outlined),
              selectedIcon: const Icon(Icons.account_circle),
              label: l.navProfile),
        ],
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Z.surface,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ذوق',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 72,
              height: 1,
              fontWeight: FontWeight.w800,
              color: Z.primary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Z A W Q',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 6,
              color: Z.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
