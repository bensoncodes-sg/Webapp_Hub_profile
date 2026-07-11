# Benson Phuah — NFC Digital Card

A Flutter web app for an NFC business card. Tap the card → this page opens →
the person can save your contact, message you (pre-typed), or open your links.

Built with: `flutter_animate`, `google_fonts`, `url_launcher`, `qr_flutter`,
`font_awesome_flutter`.

---

## Edit the content (no coding needed)

Everything you'd want to change lives in **`lib/data.dart`**:

- name, role, initials, bio
- email, phone, WhatsApp number
- LinkedIn / portfolio URLs
- the three GitHub accounts (and which is "primary")
- the pre-typed email / WhatsApp / SMS messages

Anything marked `TODO` is a placeholder — swap in the real value.

Two more spots:
- **`web/benson.vcf`** — the contact card that "Save to contacts" downloads.
  Update the name / email / phone here too so the saved contact is correct.
- **`lib/data.dart` → `cardUrl`** — set this to your live Render URL after the
  first deploy so the QR code points to the real page.

After any edit, rebuild: `flutter build web --release`.

---

## Run it locally

```bash
flutter pub get
flutter run -d chrome        # opens in Chrome
# or serve without launching a browser:
flutter run -d web-server --web-port 5599
# then open http://127.0.0.1:5599
```

---

## Deploy to Render (static site)

Render builds from a Git repo, so this needs to be pushed to GitHub first.

### 1. Put it on GitHub
```bash
cd C:\benson_nfc_card
git init
git add .
git commit -m "Benson NFC card"
git branch -M main
git remote add origin https://github.com/<your-username>/benson-nfc-card.git
git push -u origin main
```

### 2. Create the Render service
- Go to https://dashboard.render.com → **New** → **Blueprint**
- Connect the GitHub repo. Render reads `render.yaml` and configures a
  **Static Site** automatically:
  - Build command: `bash ./build.sh` (installs Flutter, then `flutter build web`)
  - Publish directory: `build/web`
- Click **Apply**. First build takes ~3–5 min (it clones the Flutter SDK).

> Prefer clicking through the dashboard instead of a Blueprint? Create a new
> **Static Site**, set the build command to `bash ./build.sh` and the publish
> directory to `build/web`. Same result.

### 3. After it's live
- Copy your Render URL (e.g. `https://benson-nfc-card.onrender.com`).
- Put it in `lib/data.dart` → `cardUrl` **and** `web/benson.vcf` → `URL:`.
- Commit + push. Render auto-redeploys, and the QR code now points to the
  real page.
- Write that same URL onto the NFC tag.

---

## Notes
- Free Render static sites are served over HTTPS on a `*.onrender.com`
  subdomain; you can attach a custom domain later in the dashboard.
- The `benson.vcf` "Save to contacts" flow is best on a phone: iOS Safari
  shows a native "Add Contact" sheet; Android downloads the `.vcf` which
  opens in Contacts.
