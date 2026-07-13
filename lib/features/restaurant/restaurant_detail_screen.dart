import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/rating_badge.dart';
import '../../core/widgets/section_label.dart';
import '../../domain/entities/restaurant.dart';
import '../lists/add_to_list_sheet.dart';
import 'review_sheet.dart';

/// Full restaurant page: hero, status, photos, review CTA, video, actions.
class RestaurantDetailScreen extends ConsumerStatefulWidget {
  const RestaurantDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  bool _hoursOpen = false;

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final r = ref.watch(restaurantRepoProvider).byId(widget.id);
    final saved = ref.watch(savedProvider).contains(r.id);
    final myReview = ref.watch(reviewsProvider)[r.id];

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _Hero(r: r, saved: saved, onSave: () {
                final added = ref.read(savedProvider.notifier).toggle(r.id);
                showSnack(context, added ? l.toastSaved : l.toastUnsaved);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(r.name,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15)),
                        ),
                        const SizedBox(width: 10),
                        RatingBadge(
                            value: myReview?.rating ?? r.rating, large: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${r.category} · ${r.priceLabel}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(r.address,
                        style: const TextStyle(
                            fontSize: 13, color: Z.onSurfaceVariant)),
                    const SizedBox(height: 12),
                    _StatusRow(
                      r: r,
                      open: _hoursOpen,
                      closedLabel: l.closedL,
                      openLabel: l.openL,
                      opensLabel: l.opens,
                      onToggle: () =>
                          setState(() => _hoursOpen = !_hoursOpen),
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: _hoursOpen
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: _HoursTable(r: r, days: l.days, label: l.hoursH),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: r.photoColors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) => _PhotoTile(
                            r: r, index: i, onTap: () => _openLightbox(r, i)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => showReviewSheet(context, ref, r),
                      child: Text(myReview == null
                          ? l.leaveReview
                          : '${l.updateReview} · ${myReview.rating.toStringAsFixed(1)}'),
                    ),
                    const SizedBox(height: 22),
                    SectionLabel(l.featuredVideo),
                    _VideoCard(r: r, l: l),
                    const SizedBox(height: 22),
                    const Divider(color: Z.outlineVariant, height: 1),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ActionPill(
                            icon: Icons.playlist_add_rounded,
                            label: l.addToList,
                            onTap: () =>
                                showAddToListSheet(context, ref, r.id)),
                        _ActionPill(
                            icon: Icons.directions_outlined,
                            label: l.directions,
                            onTap: () => Launchers.maps(r.address)),
                        _ActionPill(
                            icon: Icons.call_outlined,
                            label: l.call,
                            onTap: () => Launchers.dial(r.phone)),
                        _ActionPill(
                            icon: Icons.menu_book_outlined,
                            label: l.menuL,
                            onTap: () => _openMenu(r)),
                        _ActionPill(
                            icon: Icons.ios_share_rounded,
                            label: l.share,
                            onTap: () => Launchers.shareText(
                                '${r.name} — ${r.address}')),
                        _ActionPill(
                            icon: Icons.flag_outlined,
                            label: l.report,
                            onTap: () => _openReport(r)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () => Launchers.maps(r.name),
                        icon: const Text('G',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF4285F4))),
                        label: Text('${r.googleRating.toStringAsFixed(1)} ★',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Z.onSurface)),
                        style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: const BorderSide(color: Z.outline)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLightbox(Restaurant r, int index) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black87,
      pageBuilder: (_, __, ___) => _Lightbox(r: r, index: index),
    ));
  }

  void _openMenu(Restaurant r) {
    final l = ref.l10n;
    showAppSheet(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.menuL,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(l.menuNote,
                style: const TextStyle(
                    fontSize: 12.5, color: Z.onSurfaceVariant)),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: r.dishes.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Z.outlineVariant),
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(r.dishes[i],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600))),
                      Text('\$${8 + (i * 3) % 14}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Z.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Launchers.url(r.website),
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: Text(l.openExternal),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: const StadiumBorder()),
            ),
          ],
        ),
      ),
    );
  }

  void _openReport(Restaurant r) {
    final l = ref.l10n;
    final reasons = [l.rWrongInfo, l.rClosed, l.rLocation, l.rOther];
    var selected = 0;
    showAppSheet(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.reportH,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < reasons.length; i++)
                    ChoiceChip(
                      selected: selected == i,
                      onSelected: (_) => setSheet(() => selected = i),
                      label: Text(reasons[i]),
                      shape: const StadiumBorder(),
                      selectedColor: Z.secondaryContainer,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  showSnack(context, l.toastReport);
                },
                child: Text(l.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.r, required this.saved, required this.onSave});

  final Restaurant r;
  final bool saved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l = ProviderScope.containerOf(context).read(l10nProvider);
    return Container(
      height: 230,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(r.heroColor), Color(r.heroColor).withOpacity(0.4), Z.surface],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(Icons.arrow_back_rounded, size: 22),
                  ),
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: onSave,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          saved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          size: 18,
                          color: saved ? Z.primary : Z.onSurface,
                        ),
                        const SizedBox(width: 6),
                        Text(saved ? l.savedBtn : l.save,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.r,
    required this.open,
    required this.onToggle,
    required this.closedLabel,
    required this.openLabel,
    required this.opensLabel,
  });

  final Restaurant r;
  final bool open;
  final VoidCallback onToggle;
  final String closedLabel;
  final String openLabel;
  final String opensLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Z.outlineVariant),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            r.isClosed ? closedLabel : openLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: r.isClosed ? Z.onSurfaceVariant : Z.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Text('$opensLabel ${r.opensAt}',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              AnimatedRotation(
                turns: open ? 0.5 : 0,
                duration: const Duration(milliseconds: 180),
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HoursTable extends StatelessWidget {
  const _HoursTable({required this.r, required this.days, required this.label});

  final Restaurant r;
  final List<String> days;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Z.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label),
          for (var i = 0; i < 7; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                      width: 82,
                      child: Text(days[i],
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13))),
                  Text(r.hours[i],
                      style: const TextStyle(
                          fontSize: 13, color: Z.onSurfaceVariant)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Photo placeholder tile with a Hero to the lightbox. Swap the gradient
/// for `CachedNetworkImage` when real photo URLs are available.
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.r, required this.index, required this.onTap});

  final Restaurant r;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Color(r.photoColors[index]);
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'photo-${r.id}-$index',
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c, c.withOpacity(0.6)],
            ),
          ),
        ),
      ),
    );
  }
}

class _Lightbox extends StatelessWidget {
  const _Lightbox({required this.r, required this.index});

  final Restaurant r;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = Color(r.photoColors[index]);
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Hero(
            tag: 'photo-${r.id}-$index',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [c, c.withOpacity(0.6)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends ConsumerWidget {
  const _VideoCard({required this.r, required this.l});

  final Restaurant r;
  final L10n l;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final video = r.video;
    if (video == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Z.outlineVariant),
        ),
        child: Text(l.noVideos,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: Z.onSurfaceVariant)),
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _openVideo(context, video),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF101418),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                    radius: 18, backgroundColor: Color(0xFF37474F),
                    child: Icon(Icons.person, color: Colors.white70, size: 20)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                    Text('@${video.handle}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.music_note_rounded,
                    color: Colors.white70, size: 20),
              ],
            ),
            const Spacer(),
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                child:
                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
              ),
            ),
            const Spacer(),
            Text(l.tapWatch,
                style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, FeaturedVideo video) {
    showAppSheet(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 9 / 12,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF101418),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_outline_rounded,
                      color: Colors.white70, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => Launchers.url(video.url),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(l.openExternal),
            ),
            const SizedBox(height: 6),
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: Text(l.close)),
          ],
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Z.onSurface),
      label: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 13, color: Z.onSurface)),
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: const BorderSide(color: Z.outline),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}
