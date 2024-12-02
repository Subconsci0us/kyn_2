import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kyn_2/models/post_model.dart';
import 'package:kyn_2/features/events/post/screens/post_view.dart';
import 'package:kyn_2/core/constants/constants.dart';

class PostCard4 extends StatelessWidget {
  final Post post;

  const PostCard4({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMMM yyyy, h:mm a').format(post.createdAt);

    String imageUrl =
        post.link ?? Constants().getDefaultImageForCategory(post.category);

    return GestureDetector(
      onTap: () {
        // Navigate to PostView with the selected post
        Navigator.push(context, PostView.route(post));
      },
      child: SizedBox(
        height: 260,
        child: Card(
          color: const Color(0xFFF7F7F7),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior:
              Clip.antiAlias, // Ensures the child is clipped to the border
          child: Stack(
            children: [
              // Background Image
              CachedNetworkImage(
                imageUrl: imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 40, color: Colors.red),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              // Top-Left Label for "Emergency"
              const Positioned(
                top: 12,
                left: 12,
                child: Text(
                  "Emergency",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Title
                    Text(
                      post.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Subtitle (formatted date)
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Top-Right Badge (Optional, based on post properties)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 17, 0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
