import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this.sendMessage);

  final Function({String text, File imageFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final TextEditingController _controller = TextEditingController();

  ImagePicker _imagePicker = ImagePicker();

  bool _isComposing = false;

  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final File imgFile = File(await _imagePicker.getImage(source: ImageSource.camera).then((file) => file.path));
              widget.sendMessage(imageFile: imgFile);
            }
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Enviar uma mensagem"),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                reset();
              },
            )
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? () {
              widget.sendMessage(text: _controller.text);
              reset();
            } : null
          )
        ],
      ),
    );
  }

  void reset() {
    _controller.clear();
    setState(() {
      _isComposing = !_isComposing;
    });
  }
}
