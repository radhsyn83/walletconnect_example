import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:walletconnect/atoms/custom_dialog.dart';
import 'package:walletconnect/atoms/proposal_dialog.dart';
import 'package:walletconnect/atoms/request_dialog.dart';
import 'package:walletconnect/domain/eth_test.dart';
import 'package:walletconnect/model/proposal_model.dart';
import 'package:walletconnect/atoms/wallet.dart';
import 'package:walletconnect/model/request_model.dart';
import 'package:walletconnect/utils/storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late TextEditingController pairInputController;
  final methodChannel = MethodChannel("flutter.native/method");
  List<EthChains> chains = [];

  void sessionApprove(ProposalModel prop) {
    var arguments = prop.generateApprove();
    methodChannel.invokeMethod('approveSession', arguments);
  }

  void sessionReject(ProposalModel prop) {
    var arguments = prop.generateReject();
    methodChannel.invokeMethod('rejectSession', arguments);
  }

  void sessionDisconnect() {
    LocalStorage.sessions.then((value) async {
      var topics = value?.session?.topic;
      if (topics != null) {
        final Map<String, dynamic> arguments = new Map<String, dynamic>();
        arguments["disconnectionReason"] = "Disconnection session";
        arguments["sessionTopic"] = topics;
        await methodChannel.invokeMethod('disconnect', arguments);
        LocalStorage.clear().then(
          (value) => loadChains(),
        );
      }
    });
  }

  void pair() {
    var arguments = pairInputController.text.toString();
    methodChannel.invokeMethod('pair', arguments);
  }

  void requestApprove(RequestModel sessionRequest) {
    final Map<String, dynamic> arguments = new Map<String, dynamic>();
    arguments["sessionTopic"] = sessionRequest.topic;
    arguments["requestId"] = "${sessionRequest.request?.id}";
    methodChannel.invokeMethod('requestApprove', arguments);
  }

  void requestReject(RequestModel sessionRequest) {
    final Map<String, dynamic> arguments = new Map<String, dynamic>();
    arguments["sessionTopic"] = sessionRequest.topic;
    arguments["requestId"] = "${sessionRequest.request?.id}";
    methodChannel.invokeMethod('requestReject', arguments);
  }

  @override
  void initState() {
    chains = [];
    loadChains();
    super.initState();
  }

  @override
  void dispose() {
    pairInputController.dispose();
    super.dispose();
  }

  void loadChains() {
    LocalStorage.sessions.then((res) {
      List<EthChains> newChains = [];
      var sess = res?.session?.namespaces?.eip155?.accounts ?? [];
      sess.forEach((e) {
        var splitName = e.split(":");
        var eth = EthTestAccount.findAccount("${splitName[0]}:${splitName[1]}");
        if (eth != null) {
          newChains.add(eth);
        }
      });
      setState(() {
        chains = newChains;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            if (chains.length > 0)
              IconButton(
                  onPressed: () {
                    sessionDisconnect();
                  },
                  icon: Icon(Icons.logout)),
          ],
        ),
        body: Wallet(
            onSessionProposal: (sessionProposal) async {
              await showDialog(
                  context: context,
                  builder: (_) {
                    return CustomDialog(
                      onApprove: () {
                        sessionApprove(sessionProposal);
                        Navigator.of(context).pop();
                      },
                      onReject: () {
                        sessionReject(sessionProposal);
                        Navigator.of(context).pop();
                      },
                      child: ProposlDialog(
                        prop: sessionProposal,
                      ),
                    );
                  });
            },
            onSessionSettleResponse: (settleSession) {
              LocalStorage.setSession(settleSession);
              loadChains();
            },
            onSessionDelete: (sessionDelete) {
              LocalStorage.clear().then(
                (value) => loadChains(),
              );
            },
            onSessionRequest: (sessionRequest) async {
              await showDialog(
                  context: context,
                  builder: (_) {
                    return CustomDialog(
                      onApprove: () {
                        requestApprove(sessionRequest);
                        Navigator.of(context).pop();
                      },
                      onReject: () {
                        requestReject(sessionRequest);
                        Navigator.of(context).pop();
                      },
                      child: RequestDialog(
                        req: sessionRequest,
                      ),
                    );
                  });
            },
            child: chains.length > 0
                ? ListView.builder(
                    itemCount: chains.length,
                    itemBuilder: (context, index) {
                      var c = chains[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${c.chainName}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text("${c.addressAccount}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tidak ada session"),
                        SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () async {
                              pairInputController = TextEditingController();
                              await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return CustomDialog(
                                        isPair: true,
                                        onApprove: () {
                                          pair();
                                          Navigator.of(context).pop();
                                        },
                                        onReject: () =>
                                            Navigator.of(context).pop(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Pair"),
                                            SizedBox(height: 10),
                                            TextField(
                                              controller: pairInputController,
                                              decoration: InputDecoration(
                                                  hintText: "wc:..."),
                                            )
                                          ],
                                        ));
                                  });
                            },
                            child: Text("Pair"))
                      ],
                    ),
                  )));
  }
}
