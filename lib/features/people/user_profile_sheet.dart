import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/avatar_circle.dart';
import '../../core/widgets/rating_badge.dart';
import '../../core/widgets/section_label.dart';
import '../../domain/entities/app_user.dart';
import '../restaurant/restaurant_detail_screen.dart';

/// Opens the mini-profile for another user.
Future<void> showUserProfileSheet(
  BuildContext context,
  WidgetRef ref,
  AppUser user,
) {
  return showAppSheet(
    context,
    builder: (_) => _UserProfileSheet(user: user),
  );
}

class _UserProfileSheet extends ConsumerWidget {
  const _UserProfileSheet({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.l10n;
    final following = ref.watch(followedProvider).contains(user.name);
    final repo = ref.watch(restaurantRepoProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: AvatarCircle(color: Color(user.colorValue), size: 76),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(user.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              if (user.verified) ...[
                const SizedBox(width: 6),
                const Icon(Icons.verified_rounded,
                    size: 18, color: Z.primary),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('${l.trustedBy} ${user.trustedBy}',
                style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800,
                    color: Z.onSurfaceVariant)),
          ),
          const SizedBox(height: 16),
          following
              ? OutlinedButton(
                  onPressed: () {
                    ref.read(followedProvider.notifier).toggle(user.name);
                    showSnack(context, l.toastUnfollow(user.name));
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Z.primary),
                  ),
                  child: Text(l.followingBtn,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, color: Z.primary)),
                )
              : FilledButton(
                  onPressed: () {
                    ref.read(followedProvider.notifier).toggle(user.name);
                    showSnack(context, l.toastFollow(user.name));
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(l.follow,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
          const SizedBox(height: 22),
          SectionLabel(l.topRated),
          for (final rated in user.rated)
            Builder(builder: (context) {
              final r = repo.byId(rated.restaurantId);
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
                subtitle: Text(r.category,
                    style: const TextStyle(
                        fontSize: 12, color: Z.onSurfaceVariant)),
                trailing: RatingBadge(value: rated.score),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(id: r.id)));
                },
              );
            }),
        ],
      ),
    );
  }
}
