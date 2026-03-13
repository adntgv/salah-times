# Salah Times

Prayer times app for Astana, Kazakhstan.

## Features

- 5 daily prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha)
- Live clock with seconds
- Next prayer countdown
- Beautiful Material 3 design with gradient UI
- Dark mode support
- Responsive design for all screen sizes

## Development

Built with Flutter 3.35.7

### Getting Started

```bash
flutter pub get
flutter run
```

### Build for iOS

```bash
flutter build ipa --release
```

## CI/CD

This project uses **Xcode Cloud** for automated iOS builds:
- Builds automatically on push to `main` branch
- Uploads to TestFlight after successful build
- 25 compute hours/month free tier

## License

MIT
