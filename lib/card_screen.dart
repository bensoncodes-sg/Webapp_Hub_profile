import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'data.dart';
import 'launchers.dart';
import 'theme.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // On a phone-width viewport, fill the screen edge-to-edge.
    final isWide = size.width > 560;

    if (!isWide) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(child: _CardBody()),
      );
    }

    // On desktop, show it inside a centered phone frame so it feels like a phone.
    final frameHeight = size.height.clamp(600.0, 880.0);
    return Scaffold(
      backgroundColor: AppColors.backdrop,
      body: Center(
        child: Container(
          width: 400,
          height: frameHeight,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(38),
            border: Border.all(color: AppColors.ring, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: const _CardBody(),
        ),
      ),
    );
  }
}

/// Fills the full screen height: a fixed identity + actions cluster up top,
/// then the link cards spread through the lower half via flexible gaps, with
/// a footer anchored to the very bottom. Scrolls only if it can't all fit.
class _CardBody extends StatelessWidget {
  const _CardBody();

  Widget _fx(Widget child, int step) => child
      .animate()
      .fadeIn(duration: 420.ms, delay: (step * 60).ms)
      .slideY(begin: 0.12, end: 0, duration: 420.ms, curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    // Fills the screen when collapsed (flexible gaps expand), and scrolls
    // cleanly once the GitHub dropdown makes the content taller than the screen.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _fx(const _TopBar(), 0),
                    const SizedBox(height: 20),
                    _fx(const _Header(), 1),
                    const SizedBox(height: 26),
                    _fx(const _ComposeSection(), 2),
                    const SizedBox(height: 18),
                    _fx(const _SaveRow(), 3),
                    const SizedBox(height: 30),
                    // Links spread to fill the remaining height.
                    _fx(
                      _LinkRow(
                        icon: const FaIcon(FontAwesomeIcons.linkedinIn,
                            size: 16, color: AppColors.accent),
                        label: 'linkedin',
                        onTap: () => openUrl(CardConfig.linkedinUrl),
                      ),
                      4,
                    ),
                    const Spacer(flex: 1),
                    _fx(const _GithubTile(), 5),
                    const Spacer(flex: 1),
                    _fx(
                      _LinkRow(
                        icon: const Icon(Icons.work_outline,
                            size: 18, color: AppColors.accent),
                        label: 'portfolio',
                        onTap: () => openUrl(CardConfig.portfolioUrl),
                      ),
                      6,
                    ),
                    const Spacer(flex: 1),
                    const _Footer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
//  Top bar
// ---------------------------------------------------------------------------
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.menu, size: 21, color: AppColors.textMuted),
        Text(CardConfig.handle, style: mono(size: 12.5, color: AppColors.textMuted)),
        const Icon(Icons.ios_share, size: 20, color: AppColors.textMuted),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  Header: avatar, name, role
// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.ring, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: Image.asset(
            CardConfig.avatarAsset,
            width: 84,
            height: 84,
            fit: BoxFit.cover,
            // Falls back to the initials until the photo file is added.
            errorBuilder: (context, error, stack) => Center(
              child: Text(
                CardConfig.initials,
                style: sans(size: 29, weight: FontWeight.w500, color: AppColors.iconStrong),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(CardConfig.name, style: sans(size: 23, weight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(CardConfig.role, style: mono(size: 11.5, color: AppColors.textMuted)),
        const SizedBox(height: 12),
        // "available for work" status pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accentBgTint,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accentBorderTint),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 7),
              Text(CardConfig.status, style: mono(size: 10, color: AppColors.accent)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Bio
        Text(
          CardConfig.bio,
          textAlign: TextAlign.center,
          style: sans(size: 13, color: AppColors.textSecondary, height: 1.5),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  Compose section — "say hi" with pre-typed messages
// ---------------------------------------------------------------------------
class _ComposeSection extends StatelessWidget {
  const _ComposeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text('// say hi — message is pre-typed',
              style: mono(size: 10, color: AppColors.textFaint)),
        ),
        Row(
          children: [
            Expanded(
              child: _ComposeButton(
                icon: const Icon(Icons.mail_outline, size: 21, color: AppColors.accent),
                label: 'Email',
                onTap: composeEmail,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ComposeButton(
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 19, color: AppColors.accent),
                label: 'WhatsApp',
                onTap: composeWhatsApp,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ComposeButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.accent),
                label: 'Text',
                onTap: composeSms,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ComposeButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _ComposeButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            SizedBox(height: 22, child: Center(child: icon)),
            const SizedBox(height: 7),
            Text(label,
                style: sans(size: 11, weight: FontWeight.w500, color: AppColors.iconStrong)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Save to contacts + QR
// ---------------------------------------------------------------------------
class _SaveRow extends StatelessWidget {
  const _SaveRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Pressable(
                  onTap: () {
                    saveContact();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.borderStrong,
                        duration: const Duration(seconds: 2),
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text('Contact saved to device',
                                style: sans(size: 12, color: AppColors.textPrimary)),
                          ],
                        ),
                      ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_add_alt_1, size: 19, color: AppColors.accentInk),
                        const SizedBox(width: 9),
                        Text('Save to contacts',
                            style: sans(
                                size: 15,
                                weight: FontWeight.w500,
                                color: AppColors.accentInk)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _Pressable(
                onTap: () => _showQrSheet(context),
                child: Container(
                  width: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: AppColors.borderStrong),
                  ),
                  child: const Icon(Icons.qr_code_2, size: 24, color: AppColors.iconStrong),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('adds me to your phone in one tap',
            style: mono(size: 9.5, color: AppColors.textFaint)),
      ],
    );
  }
}

void _showQrSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surfaceAlt,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderStrong,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Text('scan to open card', style: mono(size: 11, color: AppColors.textMuted)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: CardConfig.cardUrl,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square, color: AppColors.bg),
              dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square, color: AppColors.bg),
            ),
          ),
          const SizedBox(height: 16),
          Text(CardConfig.cardUrl.replaceAll('https://', ''),
              style: mono(size: 10.5, color: AppColors.textFaint)),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
//  Link rows
// ---------------------------------------------------------------------------
class _LinkIcon extends StatelessWidget {
  final Widget icon;
  const _LinkIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }
}

class _LinkRow extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _LinkRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _LinkIcon(icon: icon),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: mono(size: 13, color: AppColors.textPrimary))),
            const Icon(Icons.arrow_outward, size: 18, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }
}

class _GithubTile extends StatefulWidget {
  const _GithubTile();

  @override
  State<_GithubTile> createState() => _GithubTileState();
}

class _GithubTileState extends State<_GithubTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Pressable(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const _LinkIcon(
                    icon: FaIcon(FontAwesomeIcons.github, size: 17, color: AppColors.accent)),
                const SizedBox(width: 14),
                Expanded(child: Text('github', style: mono(size: 13, color: AppColors.textPrimary))),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text('${CardConfig.githubs.length}',
                      style: mono(size: 9.5, color: AppColors.textFaint)),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down,
                      size: 20, color: AppColors.textFaint),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: _open
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 6),
                  child: Column(
                    children: [
                      for (final g in CardConfig.githubs)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: _GithubSubRow(account: g),
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _GithubSubRow extends StatelessWidget {
  final GithubAccount account;
  const _GithubSubRow({required this.account});

  @override
  Widget build(BuildContext context) {
    final dotColor = account.primary ? AppColors.accent : AppColors.textFaint;
    final tagColor = account.primary ? AppColors.accent : AppColors.textMuted;
    return _Pressable(
      onTap: () => openUrl(account.url),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceDeep,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFF18181B)),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(account.handle,
                  style: mono(
                      size: 11.5,
                      color: account.primary
                          ? AppColors.textPrimary
                          : AppColors.textSecondary)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: account.primary ? AppColors.accentBgTint : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: account.primary
                        ? AppColors.accentBorderTint
                        : AppColors.borderStrong),
              ),
              child: Text(account.label, style: mono(size: 9, color: tagColor)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subtle footer anchored to the bottom of the screen.
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: AppColors.border,
          margin: const EdgeInsets.only(bottom: 14),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contactless, size: 14, color: AppColors.textFaint),
            const SizedBox(width: 7),
            Text('tap · save · connect', style: mono(size: 10, color: AppColors.textFaint)),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  Shared: tactile press-scale wrapper
// ---------------------------------------------------------------------------
class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _Pressable({required this.child, required this.onTap});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  double _scale = 1;

  void _set(double v) => setState(() => _scale = v);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(0.96),
      onTapUp: (_) => _set(1),
      onTapCancel: () => _set(1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: widget.child,
        ),
      ),
    );
  }
}
