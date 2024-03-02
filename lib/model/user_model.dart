// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? userName;
    String? email;
    bool? islogin;
    List<Bookmark>? bookmark;
    List<Notification>? notification;

    UserModel({
        this.userName,
        this.email,
        this.islogin,
        this.bookmark,
        this.notification,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userName: json["userName"],
        email: json["email"],
        islogin: json["islogin"],
        bookmark: json["bookmark"] == null ? [] : List<Bookmark>.from(json["bookmark"]!.map((x) => Bookmark.fromJson(x))),
        notification: json["notification"] == null ? [] : List<Notification>.from(json["notification"]!.map((x) => Notification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
        "islogin": islogin,
        "bookmark": bookmark == null ? [] : List<dynamic>.from(bookmark!.map((x) => x.toJson())),
        "notification": notification == null ? [] : List<dynamic>.from(notification!.map((x) => x.toJson())),
    };
}

class Bookmark {
    String? id;

    Bookmark({
        this.id,
    });

    factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}

class Notification {
    String? notification;

    Notification({
        this.notification,
    });

    factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        notification: json["notification"],
    );

    Map<String, dynamic> toJson() => {
        "notification": notification,
    };
}
