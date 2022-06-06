import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect/listener.dart';
import 'package:walletconnect/model/delete_model.dart';
import 'package:walletconnect/model/proposal_model.dart';
import 'package:walletconnect/model/request_model.dart';
import 'package:walletconnect/model/settle_model.dart';

class Wallet extends StatefulWidget {
  final Widget child;
  final Function? onConnectionStateChange;
  final Function(ProposalModel sessionProposal)? onSessionProposal;
  final Function(RequestModel sessionRequest)? onSessionRequest;
  final Function(DeleteModel sessionDelete)? onSessionDelete;
  final Function(SettleModel settleSession)? onSessionSettleResponse;
  final Function? onSessionUpdateResponse;

  const Wallet(
      {Key? key,
      required this.child,
      this.onConnectionStateChange,
      this.onSessionProposal,
      this.onSessionRequest,
      this.onSessionDelete,
      this.onSessionSettleResponse,
      this.onSessionUpdateResponse})
      : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late StreamSubscription _streamSubscription;

  final pairCodeController = TextEditingController();
  final proposerPublicKeyController = TextEditingController();
  final wConnect = const MethodChannel('flutter.native/method');

  @override
  void initState() {
    _streamSubscription = eventData.listen((event) => _parseEvent(event));
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _parseEvent(String event) {
    var state = jsonDecode(event)["state"];
    var payload = jsonDecode(event)["payload"];
    print(payload);
    switch (state) {
      case "onSessionProposal":
        widget.onSessionProposal!(ProposalModel.fromJson(payload));
        break;
      case "onSessionSettleResponse":
        widget.onSessionSettleResponse!(SettleModel.fromJson(payload));
        break;
      case "onSessionDelete":
        widget.onSessionDelete!(DeleteModel.fromJson(payload));
        break;
      case "onSessionRequest":
        widget.onSessionRequest!(RequestModel.fromJson(payload));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
