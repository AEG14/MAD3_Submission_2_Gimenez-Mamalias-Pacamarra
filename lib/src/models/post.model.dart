import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int userId;
  final int id;
  final String title;
  final String body;
  bool deleted; // New property to track if post is deleted

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.deleted = false, // Default to false, meaning post is not deleted
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: int.tryParse("${json['userId']}") ?? 0,
      id: int.tryParse("${json['id']}") ?? 0,
      title: json['title'],
      body: json['body'],
      deleted: json['deleted'] ?? false, // Initialize deleted flag from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'deleted': deleted, // Include deleted flag in JSON serialization
    };
  }

  static Post empty = Post(userId: 0, id: 0, title: '', body: '');

  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    bool? deleted, // Allow updating deleted flag
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      deleted: deleted ?? this.deleted, // Preserve deleted flag if not provided
    );
  }

  @override
  List<Object?> get props => [
        userId,
        id,
        title,
        body,
        deleted
      ]; // Include deleted in equality comparison

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'Post{userId: $userId, id: $id, title: $title, body: $body, deleted: $deleted}';
  }

  String getUserId() {
    return 'UserID: $userId';
  }

  String getId() {
    return 'ID: $id';
  }

  String getTitle() {
    return 'Title: $title';
  }

  String getBody() {
    return 'Body: $body';
  }
}
