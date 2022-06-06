import 'package:walletconnect/domain/eth_test.dart';

class ProposalModel {
  String? description;
  List<String>? icons;
  String? name;
  String? proposerPublicKey;
  String? relayProtocol;
  RequiredNamespaces? requiredNamespaces;
  String? url;

  ProposalModel(
      {this.description,
      this.icons,
      this.name,
      this.proposerPublicKey,
      this.relayProtocol,
      this.requiredNamespaces,
      this.url});

  ProposalModel.fromJson(Map<String, dynamic> json) {
    if (json["description"] is String) this.description = json["description"];
    if (json["icons"] is List)
      this.icons =
          json["icons"] == null ? null : List<String>.from(json["icons"]);
    if (json["name"] is String) this.name = json["name"];
    if (json["proposerPublicKey"] is String)
      this.proposerPublicKey = json["proposerPublicKey"];
    if (json["relayProtocol"] is String)
      this.relayProtocol = json["relayProtocol"];
    if (json["requiredNamespaces"] is Map)
      this.requiredNamespaces = json["requiredNamespaces"] == null
          ? null
          : RequiredNamespaces.fromJson(json["requiredNamespaces"]);
    if (json["url"] is String) this.url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["description"] = this.description;
    if (this.icons != null) data["icons"] = this.icons;
    data["name"] = this.name;
    data["proposerPublicKey"] = this.proposerPublicKey;
    data["relayProtocol"] = this.relayProtocol;
    if (this.requiredNamespaces != null)
      data["requiredNamespaces"] = this.requiredNamespaces?.toJson();
    data["url"] = this.url;
    return data;
  }

  Map<String, dynamic> generateApprove() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    var chains = this.requiredNamespaces?.eip155?.chains ?? [];
    var methods = this.requiredNamespaces?.eip155?.methods ?? [];
    var events = this.requiredNamespaces?.eip155?.events ?? [];
    List<String> accounts = [];
    chains.forEach((e) {
      var eth = EthTestAccount.findAccount(e);
      if (eth != null) {
        accounts.add("$e:${eth.addressAccount}");
      }
    });

    data["proposerPublicKey"] = this.proposerPublicKey;
    data["namespace"] = EthTestAccount.ETH_CHAIN;
    data["accounts"] = accounts;
    data["methods"] = methods;
    data["events"] = events;
    return data;
  }

  Map<String, dynamic> generateReject() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["proposerPublicKey"] = this.proposerPublicKey;
    data["rejectionReason"] = "Rejecting Proposal";
    data["rejectionCode"] = "400";
    return data;
  }
}

class RequiredNamespaces {
  Eip155? eip155;

  RequiredNamespaces({this.eip155});

  RequiredNamespaces.fromJson(Map<String, dynamic> json) {
    if (json["eip155"] is Map)
      this.eip155 =
          json["eip155"] == null ? null : Eip155.fromJson(json["eip155"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eip155 != null) data["eip155"] = this.eip155?.toJson();
    return data;
  }
}

class Eip155 {
  List<String>? chains;
  List<String>? events;
  List<String>? methods;

  Eip155({this.chains, this.events, this.methods});

  Eip155.fromJson(Map<String, dynamic> json) {
    if (json["chains"] is List)
      this.chains =
          json["chains"] == null ? null : List<String>.from(json["chains"]);
    if (json["events"] is List)
      this.events =
          json["events"] == null ? null : List<String>.from(json["events"]);
    if (json["methods"] is List)
      this.methods =
          json["methods"] == null ? null : List<String>.from(json["methods"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chains != null) data["chains"] = this.chains;
    if (this.events != null) data["events"] = this.events;
    if (this.methods != null) data["methods"] = this.methods;
    return data;
  }
}
