import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/avatar_circle.dart';
import '../../core/widgets/section_label.dart';
import '../lists/list_detail_screen.dart';
import '../restaurant/restaurant_detail_screen.dart';
import 'activity_sheet.dart';
import 'settings_screen.dart';
import 'top8_editor_sheet.dart';

/// Profile tab: identity, activity stats, socials, Top 8 and my lists.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.l10n;
    final profile = ref.watch(profileProvider);
    final reviews = ref.watch(reviewsProvider);
    final saved = ref.watch(savedProvider);
    final top8 = ref.watch(top8Provider);
    final myLists = ref.watch(myListsProvider);
    final repo = ref.watch(restaurantRepoProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
        children: [
          Row(
            children: [
              Text(profile.nickname,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800)),
              const Spacer(),
              MenuAnchor(
                builder: (context, controller, _) => IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () => controller.isOpen
                      ? controller.close()
                      : controller.open(),
                ),
                menuChildren: [
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.ios_share_rounded, size: 18),
                    onPressed: () => Launchers.shareText(
                        'Zawq · @${profile.instagram} — ${profile.fullName}'),
                    child: Text(l.shareProfile),
                  ),
                  MenuItemButton(
                    leadingIcon:
                        const Icon(Icons.restaurant_rounded, size: 18),
                    onPressed: () => showActivitySheet(
                        context, ref, ActivityKind.visited),
                    child: Text(l.viewVisited),
                  ),
                  MenuItemButton(
                    leadingIcon:
                        const Icon(Icons.bookmark_rounded, size: 18),
                    onPressed: () =>
                        showActivitySheet(context, ref, ActivityKind.saved),
                    child: Text(l.viewSaved),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen())),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              AvatarCircle(
                color: profile.hasAvatar
                    ? Color(profile.avatarColorValue!)
                    : null,
                initials: profile.hasAvatar ? profile.initials : null,
                size: 72,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.fullName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('@${profile.instagram}',
                        style: const TextStyle(
                            fontSize: 13, color: Z.onSurfaceVariant)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Launchers.url(
                    'https://instagram.com/${profile.instagram}'),
                icon: const Icon(Icons.camera_alt_outlined,
                    color: Z.onSurfaceVariant),
                tooltip: 'Instagram',
              ),
              IconButton(
                onPressed: () => Launchers.url(
                    'https://www.tiktok.com/${profile.tiktok}'),
                icon: const Icon(Icons.music_note_rounded,
                    color: Z.onSurfaceVariant),
                tooltip: 'TikTok',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Z.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _Stat(label: l.trustedBy, value: '0'),
                _StatDivider(),
                _Stat(
                  label: l.visitedL,
                  value: '${reviews.length}',
                  onTap: () => showActivitySheet(
                      context, ref, ActivityKind.visited),
                ),
                _StatDivider(),
                _Stat(
                  label: l.savedL,
                  value: '${saved.length}',
                  onTap: () =>
                      showActivitySheet(context, ref, ActivityKind.saved),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: SectionLabel(l.top8(profile.firstName))),
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    size: 18, color: Z.onSurfaceVariant),
                onPressed: () => showTop8Editor(context, ref),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              for (var i = 0; i < 8; i++)
                if (i < top8.length)
                  _Top8Slot(
                    color: Color(repo.byId(top8[i]).heroColor),
                    rank: i + 1,
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailScreen(id: top8[i]))),
                  )
                else
                  _Top8Slot(onTap: () => showTop8Editor(context, ref)),
            ],
          ),
          const SizedBox(height: 24),
          SectionLabel(l.myListsH),
          if (myLists.isEmpty)
            Text(l.noListsBody2,
                style: const TextStyle(
                    fontSize: 13, height: 1.5, color: Z.onSurfaceVariant))
          else
            for (final fl in myLists)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 46,
                  height: 46,
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
                trailing: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: Z.onSurfaceVariant,
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ListDetailScreen(listId: fl.id))),
              ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800,
                    color: Z.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 34, color: Z.outlineVariant);
}

class _Top8Slot extends StatelessWidget {
  const _Top8Slot({this.color, this.rank, required this.onTap});

  final Color? color;
  final int? rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Z.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: color == null
              ? Border.all(color: Z.outlineVariant)
              : null,
        ),
        child: color == null
            ? const Icon(Icons.add_rounded,
                size: 20, color: Z.onSurfaceVariant)
            : Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black38,
                    child: Text('$rank',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
      ),
    );
  }
}
