import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/avatar_circle.dart';
import '../../core/widgets/section_label.dart';
import '../../core/widgets/seg_tabs.dart';
import '../../domain/entities/app_user.dart';
import 'user_profile_sheet.dart';

/// People tab: discover creators, see friends and followed accounts,
/// and invite contacts.
class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key});

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen> {
  int _tab = 0;
  String _query = '';

  bool _match(String name) =>
      _query.isEmpty || name.toLowerCase().contains(_query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final explore = ref
        .watch(userRepoProvider)
        .exploreUsers()
        .where((u) => _match(u.name))
        .toList();
    final friends = ref
        .watch(friendUsersProvider)
        .where((u) => _match(u.name))
        .toList();
    final following = ref
        .watch(followingUsersProvider)
        .where((u) => _match(u.name))
        .toList();
    final contacts = ref
        .watch(userRepoProvider)
        .contacts()
        .where(_match)
        .toList();
    final invited = ref.watch(invitedProvider);

    final users = switch (_tab) {
      0 => explore,
      1 => friends,
      _ => following,
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.navPeople,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            SegTabs(
              labels: [l.tabExplore, l.tabFriends, l.tabFollowing],
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l.searchPeople,
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Z.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 12, bottom: 16),
                children: [
                  for (final u in users) _UserRow(user: u, l: l),
                  if (_tab == 0) ...[
                    const SizedBox(height: 18),
                    SectionLabel(l.fromContacts),
                    for (final name in contacts)
                      _ContactRow(
                        name: name,
                        invited: invited.contains(name),
                        inviteLabel: l.invite,
                        invitedLabel: l.invited,
                        onInvite: () => ref
                            .read(invitedProvider.notifier)
                            .invite(name),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserRow extends ConsumerWidget {
  const _UserRow({required this.user, required this.l});

  final AppUser user;
  final L10n l;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: AvatarCircle(color: Color(user.colorValue), size: 48),
      title: Row(
        children: [
          Flexible(
            child: Text(user.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          if (user.verified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.verified_rounded, size: 16, color: Z.primary),
          ],
        ],
      ),
      subtitle: Text('${l.trustedBy} ${user.trustedBy}',
          style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              color: Z.onSurfaceVariant)),
      trailing: Icon(
        Directionality.of(context) == TextDirection.rtl
            ? Icons.chevron_left_rounded
            : Icons.chevron_right_rounded,
        color: Z.onSurfaceVariant,
      ),
      onTap: () => showUserProfileSheet(context, ref, user),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.name,
    required this.invited,
    required this.inviteLabel,
    required this.invitedLabel,
    required this.onInvite,
  });

  final String name;
  final bool invited;
  final String inviteLabel;
  final String invitedLabel;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      leading: AvatarCircle(
        color: Z.outline,
        size: 44,
        initials: name.isEmpty ? null : name[0].toUpperCase(),
      ),
      title: Text(name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      trailing: invited
          ? Text(invitedLabel,
              style: const TextStyle(
                  color: Z.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13))
          : OutlinedButton(
              onPressed: onInvite,
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: const BorderSide(color: Z.outline),
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(inviteLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Z.onSurface)),
            ),
    );
  }
}
