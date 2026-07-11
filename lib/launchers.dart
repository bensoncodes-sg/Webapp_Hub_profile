import 'package:url_launcher/url_launcher.dart';

import 'data.dart';

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
