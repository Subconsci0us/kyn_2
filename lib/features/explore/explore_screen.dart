import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/events/community/controller/community_controller.dart';
import 'package:kyn_2/features/events/post/widget/post_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Add your background image here
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true, // Ensures the title is centered
                      title: RichText(
                        text: const TextSpan(
                          text: 'Know ',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'your ',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            TextSpan(
                              text: 'neighbour',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.notifications_active),
                          onPressed: () {
                            // Add your notification action here
                          },
                        ),
                      ],
                    ),
                    // Welcome Text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Welcome ${user?.name ?? 'User'} ,',
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    // Category Pills
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CategoryPill(
                            icon: Icons.sports,
                            label: 'Sports',
                            color: Colors.red[100]!,
                          ),
                          CategoryPill(
                            icon: Icons.music_note,
                            label: 'Music',
                            color: Colors.orange[100]!,
                          ),
                          CategoryPill(
                            icon: Icons.fastfood,
                            label: 'Food',
                            color: Colors.green[100]!,
                          ),
                          CategoryPill(
                            icon: Icons.sports,
                            label: 'Sports',
                            color: Colors.red[100]!,
                          ),
                          CategoryPill(
                            icon: Icons.music_note,
                            label: 'Music',
                            color: Colors.orange[100]!,
                          ),
                          CategoryPill(
                            icon: Icons.fastfood,
                            label: 'Food',
                            color: Colors.green[100]!,
                          ),
                        ],
                      ),
                    ),
                    // Upcoming Events Section
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Posts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Event Cards
                    SizedBox(
                      height: 270,
                      child: ref.watch(getAllPostsByUser(user!.uid)).when(
                            data: (posts) {
                              if (posts.isEmpty) {
                                return const Center(
                                    child: Text('No posts available'));
                              }

                              final latestPosts = posts.take(5).toList();

                              return ListView.builder(
                                scrollDirection: Axis
                                    .horizontal, // Enable horizontal scrolling
                                itemCount: latestPosts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final post = latestPosts[index];

                                  if (post == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return Container(
                                    width: 350,
                                    child: PostCard(post: post),
                                  );
                                },
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (error, stackTrace) => Center(
                              child: Text('Error: $error'),
                            ),
                          ),
                    ),
                    // Invite Friends Section
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(88, 227, 242, 253),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Invite your friends',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Get \$20 for ticket',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'INVITE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Image.asset(
                            'assets/images/invite.png',
                            height: 100,
                            width: 180,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                    // Upcoming Events Section
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upcoming Events',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Event Cards
                    SizedBox(
                      height: 270,
                      child: ref.watch(getAllPosts).when(
                            data: (posts) {
                              if (posts.isEmpty) {
                                return const Center(
                                    child: Text('No posts available'));
                              }

                              final latestPosts = posts.take(5).toList();

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: latestPosts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final post = latestPosts[index];

                                  if (post == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return Container(
                                    width: 350,
                                    child: PostCard(post: post),
                                  );
                                },
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (error, stackTrace) => Center(
                              child: Text('Error: $error'),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const CategoryPill({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}
