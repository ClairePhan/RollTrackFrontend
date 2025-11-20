# RollTrackFrontend

A Dart web frontend application.

## Getting Started

### Prerequisites

- Dart SDK (already installed via Flutter)

### Running the Application

#### Recommended: Development with Auto-reload (webdev)

The best option for development is using `webdev`, which handles compilation and serving:

1. Install webdev globally:
```bash
dart pub global activate webdev
```

2. Run the development server:
```bash
dart pub global run webdev serve
```

This will:
- Compile your Dart code to JavaScript automatically
- Start a local development server
- Watch for file changes and automatically rebuild
- Serve at `http://localhost:8080`

#### Alternative: Manual Compilation + Dart Server

1. Compile Dart to JavaScript:
```bash
dart compile js lib/main.dart -o web/main.dart.js
```

2. Serve using the included Dart server:
```bash
dart run bin/serve.dart
```

Or specify a custom port:
```bash
dart run bin/serve.dart 3000
```

This uses a pure Dart HTTP server (no Python or Node.js needed!).

#### Build for Production

```bash
dart compile js lib/main.dart -o web/main.dart.js --minify
```

This creates an optimized, minified JavaScript file.

### Project Structure

```
RollTrackFrontend/
├── lib/
│   └── main.dart          # Main Dart application code
├── web/
│   ├── index.html         # HTML entry point
│   └── styles.css         # CSS styles
├── pubspec.yaml           # Dart package configuration
└── analysis_options.yaml  # Dart analyzer configuration
```

### Development

- Edit `lib/main.dart` to modify your application logic
- Edit `web/index.html` to modify the HTML structure
- Edit `web/styles.css` to modify the styling

### Adding Dependencies

Add dependencies to `pubspec.yaml` and run:

```bash
dart pub get
```
