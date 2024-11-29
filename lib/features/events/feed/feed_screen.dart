import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/core/common/error_text.dart';
import 'package:kyn_2/core/common/loader.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/events/community/controller/community_controller.dart';
import 'package:kyn_2/features/events/post/widget/post_search_card.dart';
import 'package:kyn_2/models/post_model.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Post> _filteredPosts = []; // List to hold filtered posts

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Search bar widget
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: _searchController,
                onChanged:
                    _filterPosts, // Call the filtering function on text change
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none, // No border
                  filled: true,
                  fillColor: const Color.fromARGB(
                      255, 255, 255, 255), // Optional, for background color
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  prefixIcon: Icon(
                    Icons.search, // The filter icon
                    color: Colors.grey[600], // Color of the icon
                  ),
                  suffixIcon: Icon(
                    Icons.filter_list_rounded, // The filter icon
                    color: Colors.grey[600], // Color of the icon
                  ),
                  focusedBorder:
                      InputBorder.none, // Remove the blue line when focused
                  enabledBorder:
                      InputBorder.none, // Ensure there's no border when enabled
                ),
              ),
            ),
          ),
          // List of posts
          Expanded(
            child: ref.watch(getAllPosts).when(
                  data: (posts) {
                    if (_searchController.text.isEmpty) {
                      _filteredPosts =
                          posts; // If no search query, show all posts
                    }
                    return ListView.builder(
                      itemCount: _filteredPosts.length, // Use filtered posts
                      itemBuilder: (BuildContext context, int index) {
                        final post = _filteredPosts[index]; // Use filtered post
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          child: PostSearchCard(post: post),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(
                      error: error.toString(),
                    );
                  },
                  loading: () =>
                      Loader(color: Colors.red), // Show a loading indicator
                ),
          ),
        ],
      ),
    );
  }

  // Function to filter posts based on search query
  void _filterPosts(String query) {
    final posts = ref.read(getAllPosts).value ?? []; // Fetch all posts
    if (query.isEmpty) {
      setState(() {
        _filteredPosts = posts; // Show all posts if search is empty
      });
    } else {
      setState(() {
        _filteredPosts = posts
            .where((post) =>
                post.title.toLowerCase().contains(query.toLowerCase()) ||
                post.title.toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter posts by title or content
      });
    }
  }
}
