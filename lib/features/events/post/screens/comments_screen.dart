import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/core/common/error_text.dart';
import 'package:kyn_2/core/common/loader.dart';
import 'package:kyn_2/features/events/post/controller/post_controller.dart';
import 'package:kyn_2/features/events/post/widget/comment_card.dart';
import 'package:kyn_2/models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  static Route<dynamic> route(String postId) => MaterialPageRoute(
        builder: (context) => CommentsScreen(postId: postId),
      );
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();
  bool showFullDescription = false;

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPostImage(data),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildPostTitleAndDescription(data),
                    ),
                    _buildCommentInputField(data),
                    _buildCommentsList(),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => Loader(color: Colors.red),
          ),
    );
  }

  Widget _buildPostImage(Post data) {
    return Stack(
      children: [
        data.link != null && data.link!.isNotEmpty
            ? Image.network(
                data.link!,
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
      ],
    );
  }

  Widget _buildPostTitleAndDescription(Post data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          showFullDescription
              ? data.description ?? ""
              : (data.description ?? "").length > 650
                  ? "${data.description!.substring(0, 650)}..."
                  : data.description ?? "",
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        if ((data.description ?? "").length > 100)
          TextButton(
            onPressed: () {
              setState(() {
                showFullDescription = !showFullDescription;
              });
            },
            child: Center(
              child: Text(
                showFullDescription ? "Show Less" : "View More",
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentInputField(Post data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onSubmitted: (val) => addComment(data),
        controller: commentController,
        decoration: const InputDecoration(
          hintText: 'What are your thoughts?',
          filled: true,
          fillColor: Colors.grey,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    return ref.watch(getPostCommentsProvider(widget.postId)).when(
          data: (comments) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                final comment = comments[index];
                return CommentCard(comment: comment);
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => Loader(color: Colors.red),
        );
  }
}
