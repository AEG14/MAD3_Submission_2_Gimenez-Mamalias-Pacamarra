import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:state_change_demo/src/models/post.model.dart';
// import 'package:state_change_demo/src/models/user.model.dart';

import 'package:state_change_demo/src/utils/utils.dart';
import 'package:state_change_demo/src/screens/edit_post.dart';

class RestDemoScreen extends StatefulWidget {
  @override
  _RestDemoScreenState createState() => _RestDemoScreenState();
}

class _RestDemoScreenState extends State<RestDemoScreen> {
  PostController controller = PostController();

  void showPostDetails(BuildContext context, int postId) async {
    Post? post = await controller.getPostById(postId);
    if (post == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(post.getTitle()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('User ID: ${post.userId}'),
                Text('Post ID: ${post.id}'),
                Text('Title: ${post.title}'),
                Text('Body: ${post.body}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        leading: IconButton(
          onPressed: () {
            controller.getPosts();
          },
          icon: const Icon(Icons.refresh),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showNewPostFunction(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            if (controller.error != null) {
              return Center(
                child: Text(controller.error.toString()),
              );
            }

            if (!controller.working) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (Post post in controller.postList)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/targaryen1.jpg',
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(height: 5),
                                          Text(
                                            '${post.getUserId()}, ${post.getId()}',
                                          ),
                                          Container(height: 5),
                                          Text(
                                            post.getTitle(),
                                          ),
                                          Container(height: 10),
                                          Text(
                                            post.getBody(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "View Details",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          EditPostDialog.show(
                                            context,
                                            controller: controller,
                                            post: post,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    showPostDetails(
                                      context,
                                      post.id,
                                    );
                                  },
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
            return const Center(
              child: SpinKitChasingDots(
                size: 54,
                color: Colors.black87,
              ),
            );
          },
        ),
      ),
    );
  }

  showNewPostFunction(BuildContext context) {
    AddPostDialog.show(context, controller: controller);
  }
}

class AddPostDialog extends StatefulWidget {
  static show(BuildContext context, {required PostController controller}) =>
      showDialog(
          context: context,
          builder: (dContext) => AddPostDialog(controller, context));
  const AddPostDialog(this.controller, this.parentContext, {super.key});

  final PostController controller;
  final BuildContext parentContext;

  @override
  State<AddPostDialog> createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  late TextEditingController bodyC, titleC;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bodyC = TextEditingController();
    titleC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: const Text("Add new post"),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              //validate unique key before adding
              await widget.controller.makePost(
                  title: titleC.text.trim(),
                  body: bodyC.text.trim(),
                  userId: 1);
              Navigator.of(context).pop();
              showDialog(
                //showDialog after this context pops, to the parentContext of this widget
                context: widget.parentContext,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Success"),
                    content: const Text("Post added successfully"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text("Add"),
        )
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Title"),
            Flexible(
              child: TextFormField(
                controller: titleC,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Title cannot be empty";
                  }
                  return null;
                },
              ),
            ),
            const Text("Content"),
            Flexible(
              child: TextFormField(
                controller: bodyC,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Content cannot be empty";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
