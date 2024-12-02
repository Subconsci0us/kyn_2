import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kyn_2/core/constants/constants.dart';
import 'package:kyn_2/features/events/post/screens/post_view.dart';
import 'package:kyn_2/models/post_model.dart';

class PostCard2 extends ConsumerWidget {
  final Post post;

  const PostCard2({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate =
        DateFormat('dd MMMM yyyy, h:mm a').format(post.createdAt);
    // Get the default image based on category
    String imageUrl =
        post.link ?? Constants().getDefaultImageForCategory(post.category);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, PostView.route(post));
      },
      child: SizedBox(
        height: 220, // Set the card height
        width: 270, // Set the card width
        child: Card(
          color: const Color(0xFFF7F7F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 140, // Adjust the image height to fit the card size
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40, color: Colors.red),
                ),
              ),
              // Title and Date Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      post.title,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontFamily: 'jakarta', // Apply Jakarta font
                                fontWeight: FontWeight.bold,
                              ),
                      maxLines: 2, // Limit title to 2 lines
                      overflow:
                          TextOverflow.ellipsis, // Use ellipsis for overflow
                    ),
                    const SizedBox(height: 4),
                    // Location (or date, if that's what you want to display here)
                    Text(
                      formattedDate, // Assuming `post.date` is a formatted date string
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'jakarta', // Apply Jakarta font
                            color: Colors.grey,
                          ),
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
