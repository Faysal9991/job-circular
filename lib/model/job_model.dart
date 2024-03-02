// To parse this JSON data, do
//
//     final jobModel = jobModelFromJson(jsonString);

import 'dart:convert';

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
    bool bookMark;

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
        bookMark: json["bookMark"],
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
    };
}
