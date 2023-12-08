import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.transferImageBack});

  final void Function(File? image) transferImageBack;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _takenImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    //XFile
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }
    // Converting XFile to a normal file
    setState(() {
      _takenImage = File(pickedImage.path);
    });

    widget.transferImageBack(_takenImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: const Text('Take Picture'),
      onPressed: _takePicture,
    );

    // To add radius, ClipRRect
    // To make tappable after adding picture to replace picture
    // Image.file to show the image on the screen

    if (_takenImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.file(
            _takenImage!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(50, 178, 96, 96),
        borderRadius: BorderRadius.circular(15.0),
      ),
      alignment: Alignment.center,
      height: 250,
      width: double.infinity,
      child: content,
    );
  }
}
