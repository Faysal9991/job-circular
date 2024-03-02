// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    String? title;
    String? discription;

    NotificationModel({
        this.title,
        this.discription,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        title: json["title"],
        discription: json["discription"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "discription": discription,
    };
}
