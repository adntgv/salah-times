# Xcode Cloud Setup Guide

## Step 1: Open Project in Xcode

On your Mac:
```bash
open ~/flutter_builds/salah_times/ios/Runner.xcworkspace
```

## Step 2: Enable Xcode Cloud

1. In Xcode, go to **Product** → **Xcode Cloud** → **Create Workflow**
2. Select your Apple ID / Team (AHGFV6BL8B)
3. Click **Get Started**

## Step 3: Configure Workflow

### General Settings
- **Name:** iOS Build & TestFlight
- **Description:** Auto-build and upload to TestFlight on push to main
- **Branch:** `main`

### Environment
- Xcode Cloud will detect the Flutter post-clone script automatically (`ios/ci_scripts/ci_post_clone.sh`)
- Xcode Version: **Latest Release** (currently 15.x)

### Start Conditions
- [x] On push to branch: `main`
- [ ] On pull request (optional)
- [ ] Manual start only

### Actions

1. **Build**
   - Scheme: `Runner`
   - Platform: `iOS`
   - Configuration: `Release`

2. **Archive** (for App Store)
   - [x] Build for distribution
   - [x] Upload to App Store Connect

### Post-Actions
- [x] **Upload to TestFlight** (enable this!)
- TestFlight Group: Internal Testing (or create a new group)

## Step 4: App Store Connect Integration

### Create App Store Connect API Key (Recommended)

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** → **Keys** (under Integrations)
3. Click **+** to generate a new API key
4. **Name:** Xcode Cloud CI
5. **Access:** Developer
6. Download the `.p8` file (you can only do this once!)
7. Note the **Key ID** and **Issuer ID**

### Add API Key to Xcode Cloud

1. In Xcode Cloud workflow settings
2. Go to **Settings** → **App Store Connect**
3. Click **+** and upload your `.p8` key file
4. Enter **Key ID** and **Issuer ID**

## Step 5: Complete Workflow Setup

1. Click **Next**
2. Review all settings
3. Click **Create Workflow**

## Step 6: First Build

Xcode Cloud will:
1. Detect the push to `main` (already done when you created the workflow)
2. Clone the repo
3. Run `ci_post_clone.sh` to install Flutter
4. Build the iOS app
5. Archive and sign
6. Upload to TestFlight

**First build takes ~15-20 minutes** (Flutter download + build)
**Subsequent builds: ~5-8 minutes** (cached Flutter)

## Step 7: Monitor Build

1. In Xcode: **Product** → **Xcode Cloud** → **Manage Workflows**
2. Or visit [App Store Connect](https://appstoreconnect.apple.com/xcode)
3. You'll get email notifications when builds complete

## Step 8: Access TestFlight Build

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. **My Apps** → **Salah Times**
3. **TestFlight** tab
4. Build will appear in ~2-5 minutes after upload
5. Add testers or test yourself via TestFlight app on iPhone

---

## Troubleshooting

### Build fails with "No such module 'Flutter'"
- Check that `ci_post_clone.sh` is executable: `chmod +x ios/ci_scripts/ci_post_clone.sh`
- Verify the script is committed to git

### Code signing errors
- Make sure your Apple Developer account is active
- Verify Team ID (AHGFV6BL8B) has valid certificates
- Enable "Automatically manage signing" in Xcode project settings

### Build takes too long (>25 min)
- You might have hit the free tier limit (25 compute hours/month)
- Check Xcode Cloud usage in App Store Connect

---

## Future Workflow

After setup:

1. **You:** Edit app on Ubuntu (or I develop it)
2. **I:** Test web version at http://192.168.0.24:9000
3. **You say:** "ready for iOS"
4. **I run:** 
   ```bash
   cd ~/workspace/flutter_projects/salah_times
   git add .
   git commit -m "Update: [description]"
   git push
   ```
5. **Xcode Cloud:** Builds iOS automatically
6. **~10 min later:** TestFlight link ready!

No Mac needed for builds anymore (except initial Xcode Cloud setup).

---

## Cost

- **Free tier:** 25 compute hours/month
- **iOS build:** ~8 minutes = 0.13 hours
- **Monthly capacity:** ~190 builds/month FREE
- **Overflow:** $0.95/hour ($7.60/hour if you exceed)

For reference: You'd need 192+ builds/month to exceed free tier.
