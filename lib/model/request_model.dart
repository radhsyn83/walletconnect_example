class RequestModel {
  String? chainId;
  PeerMetaData? peerMetaData;
  Request? request;
  String? topic;

  RequestModel({this.chainId, this.peerMetaData, this.request, this.topic});

  RequestModel.fromJson(Map<String, dynamic> json) {
    if (json["chainId"] is String) this.chainId = json["chainId"];
    if (json["peerMetaData"] is Map)
      this.peerMetaData = json["peerMetaData"] == null
          ? null
          : PeerMetaData.fromJson(json["peerMetaData"]);
    if (json["request"] is Map)
      this.request =
          json["request"] == null ? null : Request.fromJson(json["request"]);
    if (json["topic"] is String) this.topic = json["topic"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["chainId"] = this.chainId;
    if (this.peerMetaData != null)
      data["peerMetaData"] = this.peerMetaData?.toJson();
    if (this.request != null) data["request"] = this.request?.toJson();
    data["topic"] = this.topic;
    return data;
  }
}

class Request {
  int? id;
  String? method;
  String? params;

  Request({this.id, this.method, this.params});

  Request.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) this.id = json["id"];
    if (json["method"] is String) this.method = json["method"];
    if (json["params"] is String) this.params = json["params"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["method"] = this.method;
    data["params"] = this.params;
    return data;
  }
}

class PeerMetaData {
  String? description;
  List<String>? icons;
  String? name;
  String? url;

  PeerMetaData({this.description, this.icons, this.name, this.url});

  PeerMetaData.fromJson(Map<String, dynamic> json) {
    if (json["description"] is String) this.description = json["description"];
    if (json["icons"] is List)
      this.icons =
          json["icons"] == null ? null : List<String>.from(json["icons"]);
    if (json["name"] is String) this.name = json["name"];
    if (json["url"] is String) this.url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["description"] = this.description;
    if (this.icons != null) data["icons"] = this.icons;
    data["name"] = this.name;
    data["url"] = this.url;
    return data;
  }
}
