import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';
import 'theme.dart';

Future<void> _launch(Uri uri,
    {LaunchMode mode = LaunchMode.platformDefault}) async {
  try {
    await launchUrl(uri, mode: mode);
  } catch (_) {
    // Silently ignore — nothing we can do if the device has no handler.
  }
}

/// Opens the person's mail app with subject + body already filled in.
Future<void> composeEmail() {
  final uri = Uri.parse(
    'mailto:${CardConfig.email}'
    '?subject=${Uri.encodeComponent(CardConfig.emailSubject)}'
    '&body=${Uri.encodeComponent(CardConfig.emailBody)}',
  );
  return _launch(uri);
}

/// Opens WhatsApp with a pre-typed chat to Benson.
Future<void> composeWhatsApp() {
  final uri = Uri.parse(
    'https://wa.me/${CardConfig.whatsappNumber}'
    '?text=${Uri.encodeComponent(CardConfig.whatsappText)}',
  );
  return _launch(uri, mode: LaunchMode.externalApplication);
}

/// Opens the SMS app with a pre-typed text to Benson.
Future<void> composeSms() {
  final uri = Uri.parse(
    'sms:${CardConfig.phoneDial}?body=${Uri.encodeComponent(CardConfig.smsBody)}',
  );
  return _launch(uri);
}

/// Loads the hosted vCard. On iOS Safari this opens the native
/// "Add Contact" sheet; on Android it downloads benson.vcf which
/// opens straight into Contacts.
Future<void> saveContact() {
  return _launch(Uri.parse('benson.vcf'),
      mode: LaunchMode.externalApplication);
}

/// Opens any external link (LinkedIn, GitHub, portfolio) in a new tab.
Future<void> openUrl(String url) =>
    _launch(Uri.parse(url), mode: LaunchMode.externalApplication);

/// Shares the card. On phones this opens the native share sheet; if the
/// browser doesn't support the Web Share API (e.g. some desktops), it copies
/// the link to the clipboard and shows a confirmation instead.
Future<void> shareCard(BuildContext context) async {
  try {
    await SharePlus.instance.share(
      ShareParams(
        text: '${CardConfig.name} — ${CardConfig.cardUrl}',
        subject: '${CardConfig.name} · digital card',
      ),
    );
  } catch (_) {
    if (context.mounted) await copyLink(context);
  }
}

/// Copies the card link to the clipboard and confirms with a snackbar.
Future<void> copyLink(BuildContext context) async {
  await Clipboard.setData(const ClipboardData(text: CardConfig.cardUrl));
  if (context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.borderStrong,
        duration: const Duration(seconds: 2),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 16, color: AppColors.accent),
            const SizedBox(width: 8),
            Text('Link copied to clipboard',
                style: sans(size: 12, color: AppColors.textPrimary)),
          ],
        ),
      ));
  }
}
