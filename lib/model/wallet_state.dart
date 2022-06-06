class WalletState {
  String? payload;
  String? state;

  WalletState({this.payload, this.state});

  WalletState.fromJson(Map<String, dynamic> json) {
    if (json["payload"] is String) this.payload = json["payload"];
    if (json["state"] is String) this.state = json["state"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["payload"] = this.payload;
    data["state"] = this.state;
    return data;
  }
}
