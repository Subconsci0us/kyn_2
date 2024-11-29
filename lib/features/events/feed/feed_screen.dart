import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/core/common/error_text.dart';
import 'package:kyn_2/core/common/loader.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/events/community/controller/community_controller.dart';
import 'package:kyn_2/features/events/post/widget/post_search_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ref.watch(getAllPosts).when(
          data: (posts) {
            return ListView.builder(
              itemCount:
                  posts.length, // No need to add 1 for WriteSomethingWidget
              itemBuilder: (BuildContext context, int index) {
                final post = posts[index]; // Directly use the index
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  child: PostSearchCard(post: post),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              error: error.toString(),
            );
          },
          loading: () => Loader(color: Colors.red), // Show a loading indicator
        );
  }
}
