import 'dart:convert';

class TestModel {
  TestModel(
      {required this.title,
      required this.description,
      required this.image,
      this.id,
      this.date});
  int? id;
  String title;
  String description;
  String image;
  String? date;

  factory TestModel.fromJson(String str) => TestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TestModel.fromMap(Map<String, dynamic> json) => TestModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        "title": title,
        "description": description,
        "image": image,
        "date": date,
      };
}
