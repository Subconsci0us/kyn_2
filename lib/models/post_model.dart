import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Category {
  Emergency,
  Event,
  Business,
  Services,
}

class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String username;
  final String uid;
  final DateTime createdAt;
  final Category category;

  Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.createdAt,
    required this.category,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? username,
    String? uid,
    DateTime? createdAt,
    Category? category,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'category': category.name, // Convert enum to string
    };
  }

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    var createdAtData = data['createdAt'];
    DateTime createdAt;

    if (createdAtData is Timestamp) {
      createdAt = createdAtData.toDate();
    } else if (createdAtData is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtData);
    } else {
      createdAt = DateTime.now();
    }

    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      link: data['link'],
      description: data['description'],
      upvotes: List<String>.from(data['upvotes'] ?? []),
      downvotes: List<String>.from(data['downvotes'] ?? []),
      commentCount: data['commentCount']?.toInt() ?? 0,
      username: data['username'] ?? '',
      uid: data['uid'] ?? '',
      createdAt: createdAt,
      category: Category.values.firstWhere(
        (e) => e.name == data['category'],
        orElse: () => Category.Event, // Default category
      ),
    );
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      link: map['link'],
      description: map['description'],
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      commentCount: map['commentCount']?.toInt() ?? 0,
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      category: Category.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => Category.Event, // Default category
      ),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, username: $username, uid: $uid, createdAt: $createdAt, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.title == title &&
        other.link == link &&
        other.description == description &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.uid == uid &&
        other.createdAt == createdAt &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        description.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        commentCount.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        createdAt.hashCode ^
        category.hashCode;
  }
}
