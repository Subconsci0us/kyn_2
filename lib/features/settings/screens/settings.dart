import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/core/theme/theme.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/settings/screens/app_settings_screen.dart';

class Settings extends ConsumerWidget {
  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text('Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              logOut(ref);
            },
            icon: Icon(Icons.logout_outlined,
                color: Theme.of(context).appBarTheme.iconTheme?.color),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          Column(
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: CachedNetworkImageProvider(user.profilePic),
              ),
              const SizedBox(height: 10),
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Palette.lightText,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Account & Settings Section
          Text(
            'Account & Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color),
            onTap: () {
              // Add functionality here
            },
          ),
          ListTile(
            leading:
                Icon(Icons.history, color: Theme.of(context).iconTheme.color),
            title: Text(
              'My Activity',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color),
            onTap: () {
              // Add functionality here
            },
          ),
          ListTile(
            leading:
                Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
            title: Text(
              'App Settings',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color),
            onTap: () {
              Navigator.of(context).push(AppSettingsScreen.route());
            },
          ),
          const SizedBox(height: 24),

          // Support Section
          Text(
            'Support',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.person_add,
                color: Theme.of(context).iconTheme.color),
            title: Text(
              'Invite a Friend',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color),
            onTap: () {
              // Add functionality here
            },
          ),
          ListTile(
            leading:
                Icon(Icons.feedback, color: Theme.of(context).iconTheme.color),
            title: Text(
              'Suggest a Change',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color),
            onTap: () {
              // Add functionality here
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline,
                color: Theme.of(context).iconTheme.color),
            title: Text(
              'Help',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color),
            onTap: () {
              // Add functionality here
            },
          ),
        ],
      ),
    );
  }
}
