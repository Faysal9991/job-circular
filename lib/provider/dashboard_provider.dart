import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/model/menu.dart';
import 'package:job_circuler/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int selectedIndex = 0;
  chanageIndex(int index) {
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
            link: documentSnapshot.get('link') ?? "",
            bookMark: documentSnapshot.get('bookMark') ?? false,
            popular: documentSnapshot.get('popular') ?? false,
            date: documentSnapshot.get('date'),
            deadline: documentSnapshot.get('deadline'));
      }).toList();
    });
  }

  final CollectionReference _notification = FirebaseFirestore.instance.collection('notification');

  bool isShowNotification = false;
  showNotification(bool value) {
    isShowNotification = value;
    notifyListeners();
  }

  Stream<List<NotificationModel>> getNotification() {
    return _notification.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
        return NotificationModel(
            title: documentSnapshot.get('title') ?? "",
            description: documentSnapshot.get('description') ?? "",
            user: documentSnapshot.get('user') ?? "",
            id: documentSnapshot.id);
      }).toList();
    });
  }

  bool bookmark = false;
  //*----------come here
  updateNotification(
    String id,
    String title,
    String description,
    List user,
  ) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.get("userId")==null||sharedPreferences.get("userId")==""){
      EasyLoading.showToast("Please Login First!");
    }else{
      user.add(sharedPreferences.get("userId"));
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _notification.doc(id).update({
      "title": title,
      "description": description,
      "user": user,
    });
    }
    
  }

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
      bool bookmark)async {
   
    FirebaseFirestore firestore = FirebaseFirestore.instance;
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      if(sharedPreferences.get("userId")==null||sharedPreferences.get("userId")==""){
      EasyLoading.showToast("Please Login First!");
    }else{
       bool mark = !bookmark;
      firestore.collection("jobFields").doc(id).update({
      "name": jobName,
      "description": description,
      "id": id,
      "type": type,
      "subtype": subtype,
      "salary": salary,
      "jobDetails": jobDetails,
      "companyImage": companyImage,
      "list": list,
      "link": link,
      "bookMark": mark,
    });
 
    }
  }

  String search = "";
  addtoSearch(String text) {
    search = text;
    notifyListeners();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void configureFirebaseMessaging() {
    _firebaseMessaging.getToken().then((token) {});
     
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "Body",
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
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
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
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

  DateTime? selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();

  showSnakBar() {
    SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Sorry !',
        message: 'Please select a date of birth please',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.failure,
      ),
    );
    notifyListeners();
  }

  datePicker(BuildContext context) async {
    DateTime? newDateTime = await showDatePicker(
      initialDate: selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      context: context,
    );
    selectedDate = newDateTime ?? DateTime.now();
    notifyListeners();
  }

  DateTime secondDate = DateTime.now();

  SecondDatePicker(BuildContext context) async {
    DateTime? newDateTime = await showDatePicker(
      initialDate: secondDate,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
      context: context,
    );
    secondDate = newDateTime ?? DateTime.now();
    notifyListeners();
  }

  String calculateDuration() {
    if (selectedDate != null) {
      Duration difference = secondDate.difference(selectedDate!);
      int years = difference.inDays ~/ 365;
      int months = (difference.inDays % 365) ~/ 30;
      int days = (difference.inDays % 365) % 30;
      return '$years years, $months months, $days days';
    }
    return 'Please select both dates';
  }

  Stream<List<String>> getCategoryListStream() {
    // Get the document reference
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('category').doc('EEJyW5MD5xIECYYEEkFH');

    // Return a stream that listens to changes on the document reference
    return documentReference.snapshots().map((DocumentSnapshot documentSnapshot) {
      // Check if the document exists and contains the jobCategory field
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        // Get the list of strings from the jobCategory field
        List<String>? jobCategoryList = List<String>.from(documentSnapshot.get('jobCategory'));
        return jobCategoryList;
      } else {
        // Document doesn't exist or jobCategory field is empty
        return [];
      }
    });
  }

  final CollectionReference _menu = FirebaseFirestore.instance.collection('menu');

  Stream<List<Menu>> getMenu() {
    return _menu.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
        return Menu(
            name: documentSnapshot.get('name') ?? "",
            details: documentSnapshot.get('details') ?? "");
      }).toList();
    });
  }

  List<String> filter = ['All', 'Last 3 Days', 'Last 10 Days', 'Last 20 Days'];
  bool lastThreeDays = false;
  bool lastTenDays = false;
  bool lastTwineDays = false;
  bool all = false;
  String? selectedfilter;

  filerValue(String value) {
    selectedfilter = value;
    if (value == filter[0]) {
      lastThreeDays = false;
      lastTenDays = false;
      lastTwineDays = false;
      all = true;
      EasyLoading.showSuccess("All Job Showing");
    } else if (value == filter[1]) {
      lastThreeDays = true;
      lastTenDays = false;
      lastTwineDays = false;
      all = false;
      EasyLoading.showSuccess("Last 3 days Job Showing");
    } else if (value == filter[2]) {
      lastThreeDays = false;
      lastTenDays = true;
      lastTwineDays = false;
      all = false;
      EasyLoading.showSuccess("Last 10 days Job Showing");
    } else if (value == filter[3]) {
      lastThreeDays = false;
      lastTenDays = false;
      lastTwineDays = true;
      all = false;
      EasyLoading.showSuccess("Last 20 days Job Showing");
    }
    notifyListeners();
  }

  List<String> deadlineFilter = [
    "Today",
    "Tomorrow" 
    "Last three days",
    "Last ten days",
  ];
  int selectedDeadlineFilterName = 0;
  channgeDeadlineFilterName(int index) {
    selectedDeadlineFilterName = index;
    notifyListeners();
  }
}
