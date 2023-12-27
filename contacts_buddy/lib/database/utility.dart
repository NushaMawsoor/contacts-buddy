import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class Utility {
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      dataFromBase64String(base64String),
      fit: BoxFit.cover,
    );
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Uint8List uint8ListFromList(List<int> list) {
    return Uint8List.fromList(list);
  }

  static Future<List<int>> readFileBytes(String filePath) async {
    final file = File(filePath);
    return await file.readAsBytes();
  }

  // Convert an img.Image to Uint8List
  static Uint8List uint8ListFromImage(img.Image image) {
    return Uint8List.fromList(img.encodePng(image));
  }

  // Convert ImagePicker's PickedFile to Uint8List
  static Future<Uint8List?> uint8ListFromPickedFile(PickedFile pickedFile) async {
    final List<int> imageBytes = await pickedFile.readAsBytes();
    return Uint8List.fromList(imageBytes);
  }

  // Add the missing method dataFromImage
  static Uint8List dataFromImage(Image image) {
    // Implement the logic to convert Image to Uint8List here
    // Example: Convert the Image to bytes and return Uint8List
    return Uint8List(0);
  }
}
