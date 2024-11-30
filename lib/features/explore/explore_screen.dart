import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/events/community/controller/community_controller.dart';
import 'package:kyn_2/features/events/post/widget/post_card_2.dart';
import 'package:kyn_2/features/events/post/widget/post_card_3.dart';
import 'package:kyn_2/features/events/post/widget/post_card_4.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Explore",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, size: 28),
            onPressed: () {
              // Add your notification action here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar

                    // Welcome Text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Welcome ${user?.name ?? 'User'},',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Event Cards Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        height: 270,
                        child: ref.watch(getAllEmergencyonly).when(
                              data: (posts) {
                                if (posts.isEmpty) {
                                  return const Center(
                                      child: Text('No posts available',
                                          style: TextStyle(fontSize: 18)));
                                }

                                final latestPosts = posts.take(5).toList();

                                return ListView.builder(
                                  itemCount: latestPosts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final post = latestPosts[index];

                                    if (post == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: PostCard4(post: post),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (error, stackTrace) =>
                                  Center(child: Text('Error: $error')),
                            ),
                      ),
                    ),
                    // Upcoming Events Section
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        height: 230,
                        child: ref.watch(getAllEventsonly).when(
                              data: (posts) {
                                if (posts.isEmpty) {
                                  return const Center(
                                      child: Text('No posts available'));
                                }

                                final latestPosts = posts.take(5).toList();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: latestPosts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final post = latestPosts[index];

                                    if (post == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return PostCard2(post: post);
                                  },
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (error, stackTrace) =>
                                  Center(child: Text('Error: $error')),
                            ),
                      ),
                    ),
                    // Upcoming Services Section
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        height: 230,
                        child: ref.watch(getAllServicesonly).when(
                              data: (posts) {
                                if (posts.isEmpty) {
                                  return const Center(
                                      child: Text('No posts available'));
                                }

                                final latestPosts = posts.take(5).toList();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: latestPosts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final post = latestPosts[index];

                                    if (post == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: PostCard2(post: post),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (error, stackTrace) =>
                                  Center(child: Text('Error: $error')),
                            ),
                      ),
                    ),
                    // Upcoming Businesses Section
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Text(
                        'Business',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        height: 300,
                        child: ref.watch(getAllBusinessonly).when(
                              data: (posts) {
                                if (posts.isEmpty) {
                                  return const Center(
                                      child: Text('No posts available'));
                                }

                                final latestPosts = posts.take(5).toList();

                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: latestPosts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final post = latestPosts[index];

                                    if (post == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: PostCard3(post: post),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (error, stackTrace) =>
                                  Center(child: Text('Error: $error')),
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
