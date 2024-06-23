import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:state_change_demo/src/models/post.model.dart';

class PostController with ChangeNotifier {
  Map<String, Post> posts = {};
  bool working = true;
  Object? error;
  int _highestId = 0;

  List<Post> get postList => posts.values.whereType<Post>().toList();

  clear() {
    error = null;
    posts.clear();
    _highestId = 0;
    notifyListeners();
  }

  Future<Post> makePost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      working = true;
      if (error != null) error = null;

      http.Response res = await HttpService.post(
        url: "https://jsonplaceholder.typicode.com/posts",
        body: {"title": title, "body": body, "userId": userId},
      );

      if (res.statusCode != 201) {
        throw Exception("${res.statusCode} | ${res.body}");
      }

      Map<String, dynamic> result = jsonDecode(res.body);

      _highestId++;
      result['id'] = _highestId;

      if (!result.containsKey('id')) {
        throw Exception("Response does not contain an 'id' field");
      }

      Post output = Post.fromJson(result);
      posts[output.id.toString()] = output;

      working = false;
      notifyListeners();
      return output;
    } catch (e, st) {
      print(e);
      print(st);
      error = e;
      working = false;
      notifyListeners();
      return Post.empty;
    }
  }

  Future<void> getPosts() async {
    try {
      working = true;
      clear();

      http.Response res = await HttpService.get(
        url: "https://jsonplaceholder.typicode.com/posts",
      );

      if (res.statusCode != 200) {
        throw Exception("${res.statusCode} | ${res.body}");
      }

      List<dynamic> result = jsonDecode(res.body);
      posts = Map.fromIterable(
        result,
        key: (item) => (item['id']).toString(),
        value: (item) => Post.fromJson(item),
      );

      _highestId = posts.keys
          .map((e) => int.parse(e))
          .reduce((value, element) => value > element ? value : element);

      working = false;
      notifyListeners();
    } catch (e, st) {
      print(e);
      print(st);
      error = e;
      working = false;
      notifyListeners();
    }
  }

  Future<Post?> getPostById(int id) async {
    try {
      working = true;

      http.Response res = await HttpService.get(
        url: "https://jsonplaceholder.typicode.com/posts/$id",
      );

      if (res.statusCode == 404) {
        // If server returns 404, resource is not found
        // Check if we have the post locally
        Post? localPost = posts[id.toString()];
        working = false;
        return localPost;
      } else if (res.statusCode != 200) {
        throw Exception("${res.statusCode} | ${res.body}");
      }

      Map<String, dynamic> result = jsonDecode(res.body);
      Post post = Post.fromJson(result);

      working = false;
      return post;
    } catch (e, st) {
      print(e);
      print(st);
      error = e;
      working = false;
      notifyListeners();
      return null;
    }
  }

  Future<Post> updatePost({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      working = true;

      http.Response res = await HttpService.put(
        url: "https://jsonplaceholder.typicode.com/posts/$id",
        body: {"id": id, "title": title, "body": body, "userId": userId},
      );

      if (res.statusCode == 404 || res.statusCode == 500) {
        // If server returns 404, resource is not found
        // Check if we have the post locally
        Post? localPost = posts[id.toString()];

        if (localPost != null) {
          // Create a new Post object with updated values
          Post updatedPost =
              localPost.copyWith(title: title, body: body, userId: userId);

          // Update local data
          posts[updatedPost.id.toString()] = updatedPost;

          // Notify listeners
          working = false;
          notifyListeners();
          return updatedPost;
        } else {
          throw Exception(
              "Post with id $id not found locally or on the server.");
        }
      } else if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception("${res.statusCode} | ${res.body}");
      }

      Map<String, dynamic> result = jsonDecode(res.body);
      Post output = Post.fromJson(result);

      // Update local state with the updated post
      posts[output.id.toString()] = output;
      working = false;
      notifyListeners();

      return output;
    } catch (e, st) {
      print(e);
      print(st);
      error = e;
      working = false;
      notifyListeners();
      return Post.empty;
    }
  }
}

class HttpService {
  static Future<http.Response> get(
      {required String url, Map<String, dynamic>? headers}) async {
    Uri uri = Uri.parse(url);
    return http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (headers != null) ...headers
    });
  }

  static Future<http.Response> post(
      {required String url,
      required Map<dynamic, dynamic> body,
      Map<String, dynamic>? headers}) async {
    Uri uri = Uri.parse(url);
    return http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      if (headers != null) ...headers
    });
  }

  static Future<http.Response> put(
      {required String url,
      required Map<dynamic, dynamic> body,
      Map<String, dynamic>? headers}) async {
    Uri uri = Uri.parse(url);
    return http.put(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      if (headers != null) ...headers
    });
  }
}
