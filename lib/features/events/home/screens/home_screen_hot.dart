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
          'Posts',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        /*
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
        ],
        */
      ),
      body: const FeedScreen(),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            AddPostTypeScreen.route(), // Navigates to AddPostTypeScreen
          );
        },
        backgroundColor:
            const Color.fromARGB(255, 73, 73, 73), // FAB background color
        child: const Icon(Icons.add, color: Colors.white), // Plus icon
      ),
    );
  }
}
