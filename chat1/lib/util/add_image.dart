import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage({required this.addImageFunc, super.key});
  final Function(File pickedImage) addImageFunc;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File? imageFile;

  void _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxHeight: 150,);

    setState(() {
      if(pickedImage != null) {
        imageFile = File(pickedImage.path);
      }
    });

    widget.addImageFunc(imageFile!);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SizedBox(height: 20,),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            backgroundImage: imageFile == null ? null : FileImage(imageFile!),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            icon: Icon(Icons.image),
            label: Text("Add picture"),
            onPressed: () {
              _pickImage();
            },
          ),
          const SizedBox(
            height: 80,
          ),
          TextButton.icon(
            icon: Icon(Icons.close),
            label: Text("닫기"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
