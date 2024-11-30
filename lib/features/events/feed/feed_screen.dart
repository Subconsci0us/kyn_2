import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/features/events/community/controller/community_controller.dart';
import 'package:kyn_2/features/events/post/widget/post_card_3.dart';
import 'package:kyn_2/models/post_model.dart';

class FeedScreen extends ConsumerStatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Post> _filteredPosts = [];
  String _selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Update to 5 tabs: ALL, Emergency, Business, Services, Event
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged:
                          _filterPosts, // Call the filtering function on text change
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none, // No border
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // TabBar widget for category selection
            TabBar(
              tabs: const [
                Tab(text: 'ALL'),
                Tab(text: 'Business'),
                Tab(text: 'Services'),
                Tab(text: 'Event'),
              ],
              onTap: (index) {
                setState(() {
                  // Update _selectedCategory based on the selected tab
                  switch (index) {
                    case 0:
                      _selectedCategory = 'ALL';
                      break;

                    case 1:
                      _selectedCategory = 'Business';
                      break;
                    case 2:
                      _selectedCategory = 'Services';
                      break;
                    case 3:
                      _selectedCategory = 'Event';
                      break;
                  }
                  print('Selected Category: $_selectedCategory'); // Debugging
                });
              },
            ),
            // Expanded widget to fill the remaining space with posts
            Expanded(
              child: ref.watch(getAllPosts).when(
                    data: (posts) {
                      // Print all posts for debugging
                      posts.forEach((post) {
                        print(
                            'Post title: ${post.title}, Category: ${post.category}');
                      });

                      // Filter posts based on the search query
                      List<Post> searchFilteredPosts = posts
                          .where((post) => post.title
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                          .toList();

                      // Apply category filter based on the selected tab
                      if (_selectedCategory != 'ALL') {
                        // Compare category to the enum values
                        _filteredPosts = searchFilteredPosts
                            .where((post) =>
                                post.category.toString().split('.').last ==
                                _selectedCategory)
                            .toList();
                      } else {
                        _filteredPosts = searchFilteredPosts;
                      }

                      // Print filtered posts count for debugging
                      print('Filtered posts: ${_filteredPosts.length}');

                      return ListView.builder(
                        itemCount: _filteredPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = _filteredPosts[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: PostCard3(
                                post: post), // Assuming you have this widget
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(child: Text(error.toString()));
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                  ),
            ),
          ],
        ),
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
