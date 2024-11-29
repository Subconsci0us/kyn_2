import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/core/constants/constants.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/events/post/controller/post_controller.dart';
import 'package:kyn_2/features/events/post/screens/comments_screen.dart';
import 'package:kyn_2/features/events/post/screens/post_view.dart';
import 'package:kyn_2/models/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post
      post; // Ensure your Post model has required fields (title, date, image, etc.)

  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return SizedBox(
      height: 270,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, PostView.route(post));
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with Date Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: post.link ?? Constants.emergencyDefault,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            "10", // Example: "10"
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "JUNE", // Example: "JUNE"
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 50,
                    child: IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      onPressed: () {
                        // Bookmark action
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: post.uid == user?.uid
                        ? IconButton(
                            onPressed: () => deletePost(ref, context),
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          )
                        : const SizedBox
                            .shrink(), // This ensures no widget is rendered if the condition is false
                  ),
                ],
              ),

              // Title and Description Section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title Text on the left
                    Expanded(
                      child: Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Icon on the right
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, CommentsScreen.route(post.id));
                      },
                      child: const Icon(
                        Icons.comment, // Replace with your desired icon
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Footer Section with Location and Attendees
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 20),
                        SizedBox(width: 4),
                        Text(
                          "36 Guild Street London, UK ",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
