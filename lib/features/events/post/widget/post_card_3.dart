import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kyn_2/core/constants/constants.dart';
import 'package:kyn_2/features/events/post/screens/post_view.dart';
import 'package:kyn_2/models/post_model.dart';

class PostCard3 extends ConsumerWidget {
  final Post post;

  const PostCard3({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate =
        DateFormat('dd MMMM yyyy, h:mm a').format(post.createdAt);
    String imageUrl =
        post.link ?? Constants().getDefaultImageForCategory(post.category);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, PostView.route(post));
      },
      child: SizedBox(
        height: 130, // Adjusted height
        width: 300, // Adjusted width
        child: Card(
          elevation: 0,
          color: const Color(0xFFF7F7F7),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Reduced border radius
          ),
          margin: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 6), // Reduced margin
          child: Row(
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), // Reduced border radius
                  bottomLeft: Radius.circular(12), // Reduced border radius
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 100, // Reduced image width
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40, color: Colors.red),
                ),
              ),
              // Text Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        post.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontFamily: 'jakarta', // Apply Jakarta font
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2, // Limit title to 2 lines
                        overflow:
                            TextOverflow.ellipsis, // Use ellipsis for overflow
                      ),
                      const SizedBox(height: 4),
                      // Date and Time
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'jakarta',
                              color:
                                  Colors.grey[600], // Ensured contrast for date
                            ),
                      ),
                      const SizedBox(height: 4),
                      // Location or subtitle
                      Text(
                        post.username,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'jakarta',

                              color: Colors.grey[
                                  700], // Slightly lighter color for location
                            ),
                      ),
                    ],
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
