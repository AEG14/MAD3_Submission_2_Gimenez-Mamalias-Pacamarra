import 'package:flutter/material.dart';
import 'package:state_change_demo/src/utils/utils.dart';
import 'package:state_change_demo/src/models/post.model.dart';
import 'package:state_change_demo/src/screens/edit_post.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RestDemoScreen extends StatefulWidget {
  @override
  _RestDemoScreenState createState() => _RestDemoScreenState();
}

class _RestDemoScreenState extends State<RestDemoScreen> {
  final PostController controller = PostController();

  @override
  void initState() {
    super.initState();
    controller.getPosts();
  }

  void showNewPostFunction(BuildContext context) {
    // Implementation for showing a dialog to add a new post
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.toString()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
}
