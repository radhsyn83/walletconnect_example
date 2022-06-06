
class SettleModel {
  Session? session;

  SettleModel({this.session});

  SettleModel.fromJson(Map<String, dynamic> json) {
    if(json["session"] is Map)
      this.session = json["session"] == null ? null : Session.fromJson(json["session"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.session != null)
      data["session"] = this.session?.toJson();
    return data;
  }
}

class Session {
  int? expiry;
  MetaData? metaData;
  Namespaces? namespaces;
  String? topic;

  Session({this.expiry, this.metaData, this.namespaces, this.topic});

  Session.fromJson(Map<String, dynamic> json) {
    if(json["expiry"] is int)
      this.expiry = json["expiry"];
    if(json["metaData"] is Map)
      this.metaData = json["metaData"] == null ? null : MetaData.fromJson(json["metaData"]);
    if(json["namespaces"] is Map)
      this.namespaces = json["namespaces"] == null ? null : Namespaces.fromJson(json["namespaces"]);
    if(json["topic"] is String)
      this.topic = json["topic"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["expiry"] = this.expiry;
    if(this.metaData != null)
      data["metaData"] = this.metaData?.toJson();
    if(this.namespaces != null)
      data["namespaces"] = this.namespaces?.toJson();
    data["topic"] = this.topic;
    return data;
  }
}

class Namespaces {
  Eip155? eip155;

  Namespaces({this.eip155});

  Namespaces.fromJson(Map<String, dynamic> json) {
    if(json["eip155"] is Map)
      this.eip155 = json["eip155"] == null ? null : Eip155.fromJson(json["eip155"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.eip155 != null)
      data["eip155"] = this.eip155?.toJson();
    return data;
  }
}

class Eip155 {
  List<String>? accounts;
  List<String>? events;
  List<String>? methods;

  Eip155({this.accounts, this.events, this.methods});

  Eip155.fromJson(Map<String, dynamic> json) {
    if(json["accounts"] is List)
      this.accounts = json["accounts"]==null ? null : List<String>.from(json["accounts"]);
    if(json["events"] is List)
      this.events = json["events"]==null ? null : List<String>.from(json["events"]);
    if(json["methods"] is List)
      this.methods = json["methods"]==null ? null : List<String>.from(json["methods"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.accounts != null)
      data["accounts"] = this.accounts;
    if(this.events != null)
      data["events"] = this.events;
    if(this.methods != null)
      data["methods"] = this.methods;
    return data;
  }
}

class MetaData {
  String? description;
  List<String>? icons;
  String? name;
  String? url;

  MetaData({this.description, this.icons, this.name, this.url});

  MetaData.fromJson(Map<String, dynamic> json) {
    if(json["description"] is String)
      this.description = json["description"];
    if(json["icons"] is List)
      this.icons = json["icons"]==null ? null : List<String>.from(json["icons"]);
    if(json["name"] is String)
      this.name = json["name"];
    if(json["url"] is String)
      this.url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["description"] = this.description;
    if(this.icons != null)
      data["icons"] = this.icons;
    data["name"] = this.name;
    data["url"] = this.url;
    return data;
  }
}