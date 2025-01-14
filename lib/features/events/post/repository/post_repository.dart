import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kyn_2/core/constants/firebase_constant.dart';
import 'package:kyn_2/core/failure.dart';
import 'package:kyn_2/core/providers/firebase_providers.dart';
import 'package:kyn_2/core/type_defs.dart';
import 'package:kyn_2/models/comment_model.dart';
import 'package:kyn_2/models/post_model.dart';
import 'package:kyn_2/models/rsvp_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(String uid) {
    // Query posts where the userId matches the given uid
    return _posts
        .where('uid', isEqualTo: uid) // Filter posts by the user's ID
        .snapshots()
        .asyncMap((snapshot) async {
      // Convert snapshot to list of Post objects
      final posts = snapshot.docs
          .map(
            (doc) => Post.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
      return posts;
    });
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void rsvp_post(Post post, String userId, Status newStatus) async {
    final rsvpCollection = FirebaseFirestore.instance.collection('rsvps');
    final query = rsvpCollection
        .where('userId', isEqualTo: userId)
        .where('postId', isEqualTo: post.id);

    final querySnapshot = await query.get();

    if (newStatus == Status.notgoing) {
      // Remove RSVP if the user chooses 'not going'
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await rsvpCollection.doc(doc.id).delete();
        }
      }
    } else {
      // Add or update RSVP
      if (querySnapshot.docs.isNotEmpty) {
        // Update existing RSVP
        for (var doc in querySnapshot.docs) {
          await rsvpCollection.doc(doc.id).update({
            'status': newStatus.name,
            'timestamp': Timestamp.now(),
          });
        }
      } else {
        // Add new RSVP
        await rsvpCollection.add({
          'userId': userId,
          'postId': post.id,
          'status': newStatus.name,
          'timestamp': Timestamp.now(),
        });
      }
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<Comment>> getCommentsOfUserPosts(String uid) async* {
    // Step 1: Fetch all posts by the specific user
    final userPostsQuery = await _posts.where('uid', isEqualTo: uid).get();
    final postIds = userPostsQuery.docs.map((doc) => doc.id).toList();

    if (postIds.isEmpty) {
      // If the user has no posts, return an empty stream
      yield [];
      return;
    }

    // Step 2: Fetch comments for posts created by the user
    yield* _comments
        .where('postId', whereIn: postIds)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
