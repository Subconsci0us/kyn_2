import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/events/post/controller/post_controller.dart';
import 'package:kyn_2/features/events/post/screens/comments_screen.dart';
import 'package:kyn_2/features/events/user_profile/screens/user_profile.dart';
import 'package:kyn_2/models/post_model.dart';
import 'package:kyn_2/core/constants/constants.dart';
import 'package:kyn_2/models/rsvp_model.dart'; // Ensure Constants is imported

class PostView extends ConsumerStatefulWidget {
  final Post post;

  const PostView({super.key, required this.post});

  static Route route(Post post) {
    return MaterialPageRoute(
      builder: (context) => PostView(post: post),
    );
  }

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  bool showFullDescription = false;
  Status _status = Status.notgoing; // Default to 'interested'

  void deletePost(BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(widget.post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(widget.post);
  }

  void rsvp_post(WidgetRef ref, Status status) async {
    ref.read(postControllerProvider.notifier).rsvp_post(widget.post, status);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // Get the default image URL based on the post's category
    final imageUrl = widget.post.link?.isNotEmpty == true
        ? widget.post.link
        : Constants().getDefaultImageForCategory(widget.post.category);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Use the dynamic image URL
                CachedNetworkImage(
                  imageUrl: imageUrl!, // Handle null URL by providing a default
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ), // Show a loading indicator while the image loads
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  ), // Display an error icon if the image fails to load
                ),
                Container(
                  height: 250,
                  color: Colors.black.withOpacity(0.5),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.share, color: Colors.white),
                              onPressed: () {},
                            ),
                            if (widget.post.uid == user?.uid)
                              IconButton(
                                onPressed: () {
                                  deletePost(context);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.post.title,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2, // Allow up to 2 lines for the title
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis (...) if the text is still too long
                          softWrap: true, // Enable wrapping to the next line
                        ),
                      ),
                      const SizedBox(
                          width:
                              8), // Add some spacing between the text and the icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, CommentsScreen.route(widget.post.id));
                        },
                        child: const Icon(
                          Icons.comment,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, UserProfile.route(widget.post.uid));
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/logo.jpg'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.post.username,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '14 December, 2021',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '4:00PM - 9:00PM',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Gala Convention Center, 36 Guild Street, London, UK',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About Event',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    showFullDescription
                        ? widget.post.description ?? ""
                        : (widget.post.description ?? "").length > 650
                            ? "${widget.post.description!.substring(0, 650)}..."
                            : widget.post.description ?? "",
                    style:
                        const TextStyle(color: Color.fromARGB(255, 48, 48, 48)),
                  ),
                  const SizedBox(height: 8),
                  if ((widget.post.description ?? "").length > 100)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showFullDescription = !showFullDescription;
                        });
                      },
                      child: Center(
                        child: Icon(
                          showFullDescription
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down_outlined,
                          color: const Color.fromARGB(255, 90, 90, 90),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Toggle Button for RSVP status
                  Center(
                    child: ToggleButtons(
                      isSelected: [
                        _status == Status.notgoing,
                        _status == Status.interested,
                        _status == Status.going
                      ],
                      onPressed: (int index) {
                        setState(() {
                          if (index == 0) {
                            _status = Status.notgoing;
                          } else if (index == 1) {
                            _status = Status.interested;
                          } else if (index == 2) {
                            _status = Status.going;
                          }

                          // Call RSVP function when a status is selected
                          rsvp_post(ref, _status);
                        });
                      },
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child: Text(
                            'Not Going',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child: Text(
                            'Interested',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child: Text(
                            'Going',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      color: Colors.grey[700],
                      fillColor: (_status == Status.interested)
                          ? Colors.blue[600]
                          : (_status == Status.going)
                              ? Colors.green[600]
                              : Colors.grey[700],
                      borderColor: (_status == Status.interested)
                          ? Colors.blue[600]
                          : (_status == Status.going)
                              ? Colors.green[600]
                              : Colors.grey[700],
                      selectedBorderColor: (_status == Status.interested)
                          ? Colors.blue[600]
                          : (_status == Status.going)
                              ? Colors.green[600]
                              : Colors.grey[700],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
