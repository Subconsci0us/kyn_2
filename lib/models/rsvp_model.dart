import 'package:cloud_firestore/cloud_firestore.dart';

enum Status { going, interested, notgoing }

class RSVP {
  final String userId;
  final String postId;
  final DateTime timestamp;
  final Status status;

  RSVP({
    required this.userId,
    required this.postId,
    required this.timestamp,
    required this.status,
  });

  // Convert RSVP object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'postId': postId,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.name, // Convert enum to string
    };
  }

  // Create RSVP object from Firestore map
  factory RSVP.fromMap(Map<String, dynamic> map) {
    return RSVP(
      userId: map['userId'] ?? '',
      postId: map['postId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: Status.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => Status.notgoing, // Default to 'interested' if not found
      ),
    );
  }
}
