import 'package:flutter/material.dart';
import 'package:state_change_demo/src/models/post.model.dart';
import 'package:state_change_demo/src/utils/utils.dart';

class EditPostDialog extends StatefulWidget {
  static show(BuildContext context,
          {required PostController controller, required Post post}) =>
      showDialog(
          context: context,
          builder: (dContext) => EditPostDialog(controller, post));

  const EditPostDialog(this.controller, this.post, {super.key});

  final PostController controller;
  final Post post;

  @override
  State<EditPostDialog> createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController bodyC, titleC;

  @override
  void initState() {
    super.initState();
    bodyC = TextEditingController(text: widget.post.body);
    titleC = TextEditingController(text: widget.post.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: const Text("Edit post"),
      actions: [
        ElevatedButton(
          onPressed: () async {
            widget.controller.updatePost(
                id: widget.post.id,
                title: titleC.text.trim(),
                body: bodyC.text.trim(),
                userId: widget.post.userId);
            Navigator.of(context).pop();
          },
          child: const Text("Update"),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Title"),
          Flexible(
            child: TextFormField(
              controller: titleC,
            ),
          ),
          const Text("Content"),
          Flexible(
            child: TextFormField(
              controller: bodyC,
            ),
          ),
        ],
      ),
    );
  }
}
