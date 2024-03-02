
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_circuler/screens/pick_image/widget/image_compresser.dart';
class ImagePickProvider with ChangeNotifier {
  File? image;
   final ImagePicker _picker = ImagePicker();
   bool isloading = false;
  Future pickImage() async {
    isloading = true;
    notifyListeners();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = await imageCompressed(imagePathToCompress: File(pickedFile.path));
          isloading = false;
   notifyListeners();
    }
        

    
  }
}

