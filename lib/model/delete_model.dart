
class DeleteModel {
  String? reason;
  String? topic;

  DeleteModel({this.reason, this.topic});

  DeleteModel.fromJson(Map<String, dynamic> json) {
    if(json["reason"] is String)
      this.reason = json["reason"];
    if(json["topic"] is String)
      this.topic = json["topic"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["reason"] = this.reason;
    data["topic"] = this.topic;
    return data;
  }
}