import 'package:flutter/material.dart';

class AccessibilitySettings {
  final String language;
  final bool readAloud;
  final bool largeText;
  final bool highContrast;
  final bool headphones;
  final bool simpleMode;

  const AccessibilitySettings({
    this.language = 'English',
    this.readAloud = false,
    this.largeText = false,
    this.highContrast = false,
    this.headphones = false,
    this.simpleMode = true,
  });

  AccessibilitySettings copyWith({
    String? language,
    bool? readAloud,
    bool? largeText,
    bool? highContrast,
    bool? headphones,
    bool? simpleMode,
  }) {
    return AccessibilitySettings(
      language: language ?? this.language,
      readAloud: readAloud ?? this.readAloud,
      largeText: largeText ?? this.largeText,
      highContrast: highContrast ?? this.highContrast,
      headphones: headphones ?? this.headphones,
      simpleMode: simpleMode ?? this.simpleMode,
    );
  }
}

class AccessibilitySettingsScope extends InheritedWidget {
  final AccessibilitySettings settings;
  final ValueChanged<AccessibilitySettings> onChanged;

  const AccessibilitySettingsScope({
    super.key,
    required this.settings,
    required this.onChanged,
    required super.child,
  });

  static AccessibilitySettingsScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AccessibilitySettingsScope>();
    assert(scope != null, 'AccessibilitySettingsScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AccessibilitySettingsScope oldWidget) {
    return settings != oldWidget.settings;
  }
}

class AccessibilityMenuButton extends StatelessWidget {
  const AccessibilityMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: _AccessibilityMenuContent(),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.accessibility_new, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Accessibility',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessibilityMenuContent extends StatelessWidget {
  const _AccessibilityMenuContent();

  @override
  Widget build(BuildContext context) {
    final scope = AccessibilitySettingsScope.of(context);
    final settings = scope.settings;

    return SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Accessibility Options',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 12),
          _buildLanguageRow(context, settings, scope.onChanged),
          const Divider(),
          SwitchListTile(
            title: const Text('Read instructions aloud'),
            value: settings.readAloud,
            onChanged: (value) {
              scope.onChanged(settings.copyWith(readAloud: value));
            },
          ),
          SwitchListTile(
            title: const Text('Large text mode'),
            value: settings.largeText,
            onChanged: (value) {
              scope.onChanged(settings.copyWith(largeText: value));
            },
          ),
          SwitchListTile(
            title: const Text('Dark/high contrast mode'),
            value: settings.highContrast,
            onChanged: (value) {
              scope.onChanged(settings.copyWith(highContrast: value));
            },
          ),
          SwitchListTile(
            title: const Text('Headphones for privacy'),
            value: settings.headphones,
            onChanged: (value) {
              scope.onChanged(settings.copyWith(headphones: value));
            },
          ),
          SwitchListTile(
            title: const Text('Simple mode'),
            subtitle: const Text('Turn off for detailed mode'),
            value: settings.simpleMode,
            onChanged: (value) {
              scope.onChanged(settings.copyWith(simpleMode: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageRow(
    BuildContext context,
    AccessibilitySettings settings,
    ValueChanged<AccessibilitySettings> onChanged,
  ) {
    const languages = ['English', 'Spanish', 'Japanese'];

    return Row(
      children: [
        const Text('Language'),
        const Spacer(),
        DropdownButton<String>(
          value: settings.language,
          items: languages
              .map(
                (language) => DropdownMenuItem(
                  value: language,
                  child: Text(language),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            onChanged(settings.copyWith(language: value));
          },
        ),
      ],
    );
  }
}
