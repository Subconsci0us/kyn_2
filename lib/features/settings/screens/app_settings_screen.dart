import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/core/theme/theme.dart';

// Settings screen with theme toggle
class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const AppSettingsScreen(),
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Theme'),
              value: themeMode.brightness == Brightness.dark,
              onChanged: (bool value) {
                themeNotifier.toggleTheme();
              },
            ),
            // Other settings widgets can be added here
          ],
        ),
      ),
    );
  }
}
