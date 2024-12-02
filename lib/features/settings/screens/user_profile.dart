import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/events/post/controller/post_controller.dart';
import 'package:kyn_2/features/events/post/screens/comments_screen.dart';
import 'package:kyn_2/features/events/post/widget/comment_card.dart';
import 'package:kyn_2/features/events/post/widget/post_card_3.dart';

class UserProfile extends ConsumerWidget {
  final String uid;

  const UserProfile({
    super.key,
    required this.uid,
  });

  static Route route(String uid) {
    return MaterialPageRoute(
      builder: (context) => UserProfile(uid: uid),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3, // About, Event, Reviews
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ref.watch(getUserDataProvider(uid)).when(
              data: (user) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Profile Image
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.profilePic),
                    // Replace with user data
                  ),
                  const SizedBox(height: 10),
                  // Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tab Bar
                  const TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'ABOUT'),
                      Tab(text: 'EVENT'),
                      Tab(text: 'REVIEWS'),
                    ],
                  ),
                  // Tab Bar View
                  Expanded(
                    child: TabBarView(
                      children: [
                        // ABOUT Tab
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Enjoy your favorite dish and a lovely time with your friends and family. '
                            'Food from local food trucks will be available for purchase. Read More',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        // EVENT Tab: Posts by User
                        Consumer(
                          builder: (context, ref, child) {
                            final posts = ref.watch(userPostsProvider(uid));

                            return posts.when(
                              data: (postList) {
                                if (postList.isEmpty) {
                                  return const Center(
                                    child: Text('No events found.'),
                                  );
                                }
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: postList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final post = postList[index];

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
                            );
                          },
                        ),
                        // REVIEWS Tab: Comments on User's Posts
                        Consumer(
                          builder: (context, ref, child) {
                            final comments =
                                ref.watch(getCommentsProvider(uid));

                            return comments.when(
                              data: (commentList) {
                                if (commentList.isEmpty) {
                                  return const Center(
                                    child: Text('No reviews yet.'),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: commentList.length,
                                  itemBuilder: (context, index) {
                                    final comment = commentList[index];

                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to CommentScreen when a comment is tapped
                                        Navigator.push(
                                          context,
                                          CommentsScreen.route(comment.postId),
                                        );
                                      },
                                      child: CommentCard(comment: comment),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (error, stackTrace) =>
                                  Center(child: Text('Error: $error')),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: ${error.toString()}')),
            ),
      ),
    );
  }
}
