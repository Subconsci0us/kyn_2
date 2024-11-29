import 'package:flutter/material.dart';
import 'package:kyn_2/models/post_model.dart';

class PostView extends StatefulWidget {
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

class _PostViewState extends State<PostView> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with background image
            Stack(
              children: [
                widget.post.link != null && widget.post.link!.isNotEmpty
                    ? Image.network(
                        widget.post.link!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/logo.jpg",
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Event details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/logo.jpg'),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.post.username,
                          style: const TextStyle(fontSize: 16)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
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
                      SizedBox(height: 12), // Spacing between rows

                      // Time
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
                      SizedBox(height: 12), // Spacing between rows

                      // Location
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

                  // About Event
                  const Text(
                    'About Event',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Description with "View More" Button
                  Text(
                    showFullDescription
                        ? widget.post.description ?? ""
                        : (widget.post.description ?? "").length > 650
                            ? "${widget.post.description!.substring(0, 650)}..."
                            : widget.post.description ?? "",
                    style: TextStyle(color: Colors.grey[700]),
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
                        child: Text(
                          showFullDescription ? "Show Less" : "View More",
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Attending Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text("Attending"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
