# Electricity Calculator

A Flutter app to track electricity consumption and costs for multiple meters, with tiered pricing for household and flat rates for industrial/commercial. Supports English and Arabic.

![App Icon](assets/icon.png)

## Features

- **Multi‑meter support** – add, rename, delete, and set a default meter.
- **Period‑based tracking** – each meter has 2‑month billing periods.
- **Tiered pricing** (household) – first 300 kWh at 6 SYP/kWh, above at 14 SYP/kWh.
- **Flat rate** (industrial/commercial) – 14 SYP/kWh.
- **Old & new SYP display** – shows both currency formats.
- **History** – expandable periods with detailed tier costs and readings.
- **Chart** – consumption bar chart for the last 6 periods.
- **Localisation** – full English and Arabic support (RTL).
- **Onboarding & tutorial** – guides new users.

## Screenshots

| Home Page | History | Add Reading |
|-----------|---------|-------------|
| ![Home](screenshots/home.png) | ![History](screenshots/history.png) | ![Add](screenshots/add.png) |

*(Replace with actual screenshots)*

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/KhaldoonAlhaj/electricity-calculator.git
   cd electricity-calculator
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localisations:
   ```bash
   flutter gen-l10n
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Building a release APK

```bash
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## Dependencies

- `sqflite` – local database
- `url_launcher` – open email/telegram links
- `fl_chart` – consumption chart
- `intl` – date and number formatting
- `path` – database file path
- `provider` – state management
- `shared_preferences` – persistent preferences (language, onboarding)
- `flutter_localizations` – ARB localisation support

## Folder Structure

```
lib/
├── database/          – SQLite helper
├── l10n/              – ARB localisation files
├── models/            – data models
├── providers/         – LocaleProvider
├── utils/             – responsive, navigation
├── views/             – all UI pages
├── widgets/           – reusable widgets
└── main.dart
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is open‑source and available under the **MIT License** – see the [LICENSE](LICENSE) file for details.

## Contact

Developer: Khaldoun Alhaj  
Email: khaldoon.alhaj@gmail.com  
Telegram: @Khaldoon_Alhaj