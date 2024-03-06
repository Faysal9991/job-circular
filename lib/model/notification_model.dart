// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    String? title;
    String? description;
    List<dynamic>? user;
    String? id;

    NotificationModel({
        this.title,
        this.description,
        this.user,
        this.id,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        title: json["title"],
        description: json["description"],
        user: json["user"] == null ? [] : List<dynamic>.from(json["user"]!.map((x) => x)),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x)),
        "id": id,
    };
}
