import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:job_circuler/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  UserModel userModel = UserModel();
  dynamic profile;
  bool isLogin = false;
  bool isLoading = false;

  dynamic response;
  String? userId;

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    EasyLoading.show(status: "Creating Profile");
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        "userName": username,
        "email": email,
        "islogin": false,
        "notification": [
          {"notification": ""}
        ]
      });
      userId = userCredential.user!.uid;
      prefs.setString("userId", userCredential.user!.uid);
      EasyLoading.showSuccess("Successful");
      return true;
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
      return false;
    }
  }

  bool isdark = false;
  changeTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isdark = value;

    prefs.setBool("isdark", isdark);
    notifyListeners();
  }

  DocumentSnapshot? userDetails;
  Future<bool> signIn(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    EasyLoading.show(status: "Logging In");
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      userId = userCredential.user!.uid;
      prefs.setString("userId", userCredential.user!.uid);

      await firestore.collection("users").doc(userId).get().then((value) {
        userModel = UserModel.fromJson(value.data() as Map<String, dynamic>);
      });
      EasyLoading.showSuccess("Successful");

      return true;
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
      return false;
    }
  }

  getUserDetails() async {
    isLoading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("userId") == null) {
      EasyLoading.showInfo("create account please");
    }else{
       String id = prefs.getString("userId")!;
    await firestore.collection("users").doc(id).get().then((value) {
      userModel = UserModel.fromJson(value.data() as Map<String, dynamic>);

      isLoading = false;
      notifyListeners();
    });
    }
  }

  forgetPassword(String email) {
    auth.sendPasswordResetEmail(email: email);
    EasyLoading.showSuccess(
        "Please reset your password link send in your Email");
    notifyListeners();
  }

  Future<bool> getLoginAccess() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.get("userId") != null) {
      isLogin = true;
      return true;
    } else {
      isLogin = false;
      return false;
    }
  }

  logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    userId = "";
    sharedPreferences.remove("userId");
    notifyListeners();
  }

  getUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("userId");
  }

  getTheme() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    isdark = sharedPreferences.getBool("isdark") ?? false;
    notifyListeners();
  }

  int selectedIndex = 0;
  changeselectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
