// ---------------------------------------------------------------------------
//  EDIT THIS FILE to update the card. No UI code needs to change.
//  Anything marked TODO is a placeholder — swap in the real value.
// ---------------------------------------------------------------------------

class GithubAccount {
  final String handle;
  final String url;
  final String label; // shown as the little tag: personal / work / intern
  final bool primary; // the one highlighted in green as your main identity

  const GithubAccount(this.handle, this.url, this.label, {this.primary = false});
}

class CardConfig {
  CardConfig._();

  // ---- Identity ----------------------------------------------------------
  static const String name = 'Benson Phuah';
  static const String handle = '~/benson-phuah';
  static const String role = 'IT student · developer';
  static const String initials = 'BP';
  // Drop your photo at this path (assets/images/benson.jpg). Until it exists,
  // the card falls back to the initials above.
  static const String avatarAsset = 'assets/images/benson.jpg';
  static const String status = 'open to internships';
  static const String bio =
      'Final-year ITE student building web and mobile projects. '
      'Learning in public, one build at a time.';

  /// The URL this card is hosted at — this is what the QR code encodes.
  /// TODO: replace with your real Render URL after the first deploy.
  static const String cardUrl = 'https://benson-phuah-card.onrender.com';

  // ---- Contact (used by the compose actions + the vCard) -----------------
  static const String email = 'bensonphuah@gmail.com';

  static const String phoneDial = '+6589181320'; // used by sms: and tel:
  static const String whatsappNumber = '6589181320'; // used by wa.me/<number>

  // ---- Links -------------------------------------------------------------
  static const String linkedinUrl = 'https://www.linkedin.com/in/benson-phuah';
  static const String portfolioUrl = 'https://benson-eportfolio-personal.onrender.com/';

  static const List<GithubAccount> githubs = [
    GithubAccount('bensoncodes-sg', 'https://github.com/bensoncodes-sg',
        'personal',
        primary: true),
    GithubAccount(
        'developerokc5-max', 'https://github.com/developerokc5-max', 'work'),
    GithubAccount(
        'internproj28-1vafk', 'https://github.com/internproj28-1vafk', 'intern'),
  ];

  // ---- Pre-typed messages ------------------------------------------------
  //  Written from the perspective of the person who just tapped your card,
  //  so they only have to hit "send". The trailing "—" / "..." invites them
  //  to sign their name, so you instantly know who reached out.
  static const String emailSubject = 'Great meeting you, Benson';
  static const String emailBody =
      "Hi Benson — I just tapped your card and wanted to connect. "
      "Let's keep in touch! —";
  static const String whatsappText =
      "Hi Benson! Great meeting you — I got your card and wanted to say hi. "
      "This is ...";
  static const String smsBody =
      "Hi Benson, great meeting you! Saving your number now — this is ...";
}
