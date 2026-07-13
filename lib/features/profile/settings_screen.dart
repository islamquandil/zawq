import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/launchers.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/avatar_circle.dart';
import '../../core/widgets/section_label.dart';
import 'avatar_picker_sheet.dart';

/// Settings: editable personal info, socials, public-profile gate,
/// Google Maps import, support, and logout.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _first;
  late final TextEditingController _last;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _nick;
  late final TextEditingController _insta;
  late final TextEditingController _tiktok;

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileProvider);
    _first = TextEditingController(text: p.firstName);
    _last = TextEditingController(text: p.lastName);
    _email = TextEditingController(text: p.email);
    _phone = TextEditingController(text: p.phone);
    _nick = TextEditingController(text: p.nickname);
    _insta = TextEditingController(text: p.instagram);
    _tiktok = TextEditingController(text: p.tiktok);
  }

  @override
  void dispose() {
    for (final c in [_first, _last, _email, _phone, _nick, _insta, _tiktok]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _dirty {
    final p = ref.read(profileProvider);
    return _first.text != p.firstName ||
        _last.text != p.lastName ||
        _email.text != p.email ||
        _phone.text != p.phone ||
        _nick.text != p.nickname ||
        _insta.text != p.instagram ||
        _tiktok.text != p.tiktok;
  }

  void _save() {
    final l = ref.read(l10nProvider);
    final p = ref.read(profileProvider);
    ref.read(profileProvider.notifier).update(p.copyWith(
          firstName: _first.text.trim(),
          lastName: _last.text.trim(),
          email: _email.text.trim(),
          phone: _phone.text.trim(),
          nickname: _nick.text.trim(),
          instagram: _insta.text.trim(),
          tiktok: _tiktok.text.trim(),
        ));
    setState(() {});
    showSnack(context, l.toastChanges);
  }

  void _openImport() {
    final l = ref.read(l10nProvider);
    showAppSheet(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.importH,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(l.importBody,
                style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Z.onSurfaceVariant)),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                ref.read(savedProvider.notifier).addAll(const [2, 3, 4]);
                Navigator.pop(ctx);
                showSnack(context, l.toastImport);
              },
              child: Text(l.importDo),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final l = ref.read(l10nProvider);
    final ok = await confirmSheet(
      context,
      title: l.logoutConfirm,
      confirmLabel: l.logout,
      cancelLabel: l.cancel,
      destructive: true,
    );
    if (ok && mounted) {
      resetSession(ref);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = ref.l10n;
    final profile = ref.watch(profileProvider);
    final reviews = ref.watch(reviewsProvider);
    final isPublic = ref.watch(publicProfileProvider);

    final remaining = (10 - reviews.length).clamp(0, 10);
    final canGoPublic = profile.hasAvatar && remaining == 0;
    final String? gateMessage = canGoPublic
        ? null
        : !profile.hasAvatar && remaining > 0
            ? l.publicGate(remaining)
            : !profile.hasAvatar
                ? l.publicGateAvatar
                : l.publicGateReviews(remaining);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.profileTitle),
        backgroundColor: Z.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Center(
                child: Stack(
                  children: [
                    AvatarCircle(
                      color: profile.hasAvatar
                          ? Color(profile.avatarColorValue!)
                          : null,
                      initials:
                          profile.hasAvatar ? profile.initials : null,
                      size: 88,
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: Material(
                        color: Z.primary,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => showAvatarPicker(context, ref),
                          child: const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.edit_rounded,
                                size: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SectionLabel(l.personalInfo),
              _Field(label: l.firstName, controller: _first,
                  onChanged: () => setState(() {})),
              _Field(label: l.lastName, controller: _last,
                  onChanged: () => setState(() {})),
              _Field(label: l.email, controller: _email,
                  keyboard: TextInputType.emailAddress,
                  onChanged: () => setState(() {})),
              _Field(label: l.phone, controller: _phone,
                  keyboard: TextInputType.phone,
                  onChanged: () => setState(() {})),
              _Field(label: l.nickname, controller: _nick,
                  onChanged: () => setState(() {})),
              const SizedBox(height: 18),
              SectionLabel(l.connectSocials),
              _Field(label: 'Instagram', controller: _insta,
                  onChanged: () => setState(() {})),
              _Field(label: 'TikTok', controller: _tiktok,
                  onChanged: () => setState(() {})),
              const SizedBox(height: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _dirty ? 1 : 0.45,
                child: FilledButton(
                  onPressed: _dirty ? _save : null,
                  child: Text(l.saveChanges),
                ),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.publicProfile,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(l.publicSub,
                    style: const TextStyle(fontSize: 12.5)),
                value: isPublic,
                onChanged: canGoPublic
                    ? (v) {
                        ref.read(publicProfileProvider.notifier).state = v;
                        if (v) showSnack(context, l.toastPublicOn);
                      }
                    : (_) => showSnack(context, gateMessage!),
              ),
              if (gateMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Z.tertiaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(gateMessage,
                      style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: Z.tertiary,
                          fontWeight: FontWeight.w600)),
                ),
              const SizedBox(height: 20),
              const Divider(color: Z.outlineVariant, height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.download_rounded,
                    color: Z.onSurfaceVariant),
                title: Text(l.importMaps,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: _openImport,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.support_agent_rounded,
                    color: Z.onSurfaceVariant),
                title: Text(l.support,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () =>
                    Launchers.email('support@zawq.app', subject: 'Zawq'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout_rounded, color: Z.error),
                title: Text(l.logout,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Z.error)),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.keyboard,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Z.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
