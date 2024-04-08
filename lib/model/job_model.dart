// To parse this JSON data, do
//
//     final jobModel = jobModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

JobModel jobModelFromJson(String str) => JobModel.fromJson(json.decode(str));

String jobModelToJson(JobModel data) => json.encode(data.toJson());

class JobModel {
    String name;
    String description;
    String id;
    String type;
    String subtype;
    String salary;
    String jobDetails;
    String companyImage;
    List<dynamic> list;
    String link;
    List<dynamic> bookMark;
    bool popular;
    Timestamp date;
    Timestamp deadline;
    JobModel({
        required this.name,
        required this.description,
        required this.id,
        required this.type,
        required this.subtype,
        required this.salary,
        required this.jobDetails,
        required this.companyImage,
        required this.list,
        required this.link,
        required this.bookMark,
         required this.popular,
          required this.date,
          required this.deadline
    });

    factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        name: json["name"],
        description: json["description"],
        id: json["id"],
        type: json["type"],
        subtype: json["subtype"],
        salary: json["salary"],
        jobDetails: json["jobDetails"],
        companyImage: json["companyImage"],
        list: List<dynamic>.from(json["list"].map((x) => x)),
        link: json["link"],
        bookMark: List<dynamic>.from(json["bookMark"].map((x) => x)),
        popular: json["popular"],
        date: json["date"],
        deadline:json["deadline"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "id": id,
        "type": type,
        "subtype": subtype,
        "salary": salary,
        "jobDetails": jobDetails,
        "companyImage": companyImage,
        "list": List<dynamic>.from(list.map((x) => x)),
        "link": link,
        "bookMark": bookMark,
        "popular":popular,
        "date" : date,
        "deadline":deadline
    };
}
