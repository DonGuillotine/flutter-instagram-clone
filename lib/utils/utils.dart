import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// To Pick an Image from gallery using the Image_Picker package

pickImage(ImageSource source) async {
  // Instantiating the Image Picker Class

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image Selected');
}

// To show a snack bar
showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
