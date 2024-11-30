import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyn_2/features/events/feed/feed_screen.dart';
import 'package:kyn_2/features/events/post/screens/add_post_type_screen.dart'; // Import the screen

class WhatshotHomeScreen extends ConsumerWidget {
  const WhatshotHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Posts',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          // Plus icon button on the right side of the app bar
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to AddPostTypeScreen when tapped
              Navigator.of(context).push(
                AddPostTypeScreen.route(),
              );
            },
          ),
        ],
      ),
      body: FeedScreen(),
      // Floating Action Button (optional, if you want another button in the body)
    );
  }
}
