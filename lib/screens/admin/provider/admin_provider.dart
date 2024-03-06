import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:job_circuler/model/job_model.dart';

class AdminProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
   Future init() async {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // get the device fcm token
    final token = await firebaseMessaging.getToken();
    print("device token: $token");
  }
  final List<String> type = [
    "All",
    "Govt",
    "Private",
    "Bank",
    "NGO",
    "Pharma",
    "Teletalk",
    "Notice"
  ];

  final List<String> subType = [
    'Full time',
    'Part time',
    'Any Where',
  ];
  bool isLoading = false;
  var cloudinary = Cloudinary.signedConfig(
    apiKey: "656167663123838",
    apiSecret: "4-nOTCXHHCa98wLr5cwm3dGZSyo",
    cloudName: "dlexoqtcj",
  );

  List imageList = [];
  String companyPicture = "";

  void uploadImages(File imagePath, Function callback, {bool isSingle = false}) async {
    isLoading = true;
    notifyListeners();
    CloudinaryResponse response = await cloudinary.upload(
        file: imagePath.path, fileName: 'public', progressCallback: (int value, int data) {});
    if (response.statusCode == 200) {
      // Successfully uploaded
      if (isSingle) {
        companyPicture = response.secureUrl!;
      } else {
        imageList.add(response.secureUrl!);
        notifyListeners();
      }
      callback(200);
    } else {
      callback(300);
      print('Error during upload. Status code: ${response.statusCode}');
    }
    isLoading = false;
   notifyListeners();
  }

  final CollectionReference _jobdata = FirebaseFirestore.instance.collection('jobFields');

  Stream<List<JobModel>> getAllFood() {
    return _jobdata.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
        return JobModel(
            name: documentSnapshot.get('name') ?? "",
            description: documentSnapshot.get('description') ?? "",
            id: documentSnapshot.id,
            type: documentSnapshot.get('type') ?? "",
            subtype: documentSnapshot.get('subtype') ?? "",
            salary: documentSnapshot.get('salary') ?? "",
            jobDetails: documentSnapshot.get('jobDetails') ?? "",
            companyImage: documentSnapshot.get('companyImage') ?? "",
            list: documentSnapshot.get('list') ?? [],
            link: documentSnapshot.get('link')??"",
            bookMark: documentSnapshot.get('bookMark')??false
            );
      }).toList();
    });
  }

  Future<bool> addNewJob({
    required String jobName,
    required String description,
    required String type,
    required String subtype,
    required String jobDetails,
    required String salary,
    required String companyImage,
    required List image,
     required String link,
  }) async {
    // Obtain shared preferences.
    EasyLoading.show(status: "Creating new Job");
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      firestore.collection("jobFields").add({
        "name": jobName,
        "description": description,
        "type": type,
        "subtype": subtype,
        "salary": salary,
        "jobDetails": jobDetails,
        "companyImage": companyImage,
        "list": image,
        "bookMark":false
      }).then((value) {
        print("-------${value.id}");
      });
      EasyLoading.showSuccess("Successful");
      return true;
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
      return false;
    }
  }


 Future<bool> sendNotificationLocal({
    required String title,
    required String description,
  }) async {
    // Obtain shared preferences.
    EasyLoading.show(status: "Creating new notification");
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      firestore.collection("notification").add({
        "title": title,
        "description": description,
        "user":[]
      }).then((value) {});
      EasyLoading.showSuccess("Successful");
      return true;
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
      return false;
    }
  }

  removeJob(String id) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("jobFields").doc(id).delete();
  }

    

}
