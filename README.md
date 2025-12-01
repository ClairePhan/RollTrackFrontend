# RollTrackFrontend

A Flutter mobile app for RollTrack - martial arts class tracking, optimized for tablets.

## Getting Started

### Prerequisites

- Flutter SDK (already installed)
- Dart SDK (comes with Flutter)

### Running the Application

#### Development Mode

1. Get dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

This will:
- Launch the app on your connected device/emulator
- Enable hot reload for instant updates
- Show debug information

#### Running on Specific Platforms

**iOS Simulator:**
```bash
flutter run -d ios
```

**Android Emulator:**
```bash
flutter run -d android
```

**Web (for testing):**
```bash
flutter run -d chrome
```

**Tablet/Physical Device:**
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

### Project Structure

```
RollTrackFrontend/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/
│   │   └── class_model.dart   # Class data model
│   └── screens/
│       ├── landing_screen.dart    # Welcome/QR code screen
│       └── classes_screen.dart    # Classes list screen
├── pubspec.yaml               # Flutter dependencies
└── analysis_options.yaml      # Linter configuration
```

### Features

- **Landing Screen**: Welcome page with QR code and "Touch" button
- **Classes Screen**: Grid view of martial arts classes with details
- **Tablet Optimized**: Responsive layout designed for tablet use
- **Navigation**: Smooth transitions between screens
- **QR Code**: Real QR code generation using qr_flutter package

### Development

- Edit `lib/screens/` to modify screen layouts
- Edit `lib/models/` to modify data models
- Hot reload is enabled - save files to see changes instantly

### Adding Dependencies

Add dependencies to `pubspec.yaml` and run:

```bash
flutter pub get
```

### Key Dependencies

- `flutter`: Core Flutter framework
- `qr_flutter`: QR code generation and display
- `cupertino_icons`: iOS-style icons
