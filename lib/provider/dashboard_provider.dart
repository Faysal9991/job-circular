
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/model/notification_model.dart';

class DashBoardProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _jobdata = FirebaseFirestore.instance.collection('jobFields');
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
  int selectedIndex =0;
  chanageIndex (int index){
    selectedIndex = index;
    notifyListeners();
  }
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
            link: documentSnapshot.get('link') ??"",
            bookMark: documentSnapshot.get('bookMark')??false);
      }).toList();
    });
  }
final CollectionReference _notification = FirebaseFirestore.instance.collection('notification');


Stream<List<NotificationModel>> getNotification() {
  return _notification.snapshots().map((QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      return NotificationModel(
        title: documentSnapshot.get('title') ?? "",
        discription: documentSnapshot.get('description') ?? "",
      );
    }).toList();
  });
}
 bool bookmark = false;
 
  updateBookmark(
  String jobName,
  String description,
  String id,
  String type,
  String subtype,
  String salary,
  String jobDetails,
  String companyImage,
  List list,
  String link,
  bool bookmark
  ) {
   bool mark = !bookmark;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("jobFields").doc(id).update(
      {   "name":jobName,
         "description":description,
         "id":id,
         "type":type,
         "subtype":subtype,
         "salary":salary,
         "jobDetails":jobDetails,
         "companyImage":companyImage,
         "list":list,
         "link":link,
         "bookMark":mark,
        }
    );
  }
 String search ="";
 addtoSearch(String text){
  search = text;
  notifyListeners();
 }
   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

void configureFirebaseMessaging() {
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.title}");
      _showLocalNotification(
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "Body",
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened by notification: ${message.notification?.title}");
      // Handle the notification when the app is opened from the background
    });
  }
 
  

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
 void configureLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change to your own channel ID
      'your_channel_name', // Change to your own channel name // Change to your own channel description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'payload',
    );
  }



}
