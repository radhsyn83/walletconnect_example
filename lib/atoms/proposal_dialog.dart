import 'package:flutter/material.dart';
import 'package:walletconnect/model/proposal_model.dart';
import 'package:collection/collection.dart';

class ProposlDialog extends StatelessWidget {
  final ProposalModel prop;
  const ProposlDialog({Key? key, required this.prop}) : super(key: key);

  String chainsGenerate() {
    var chains = prop.requiredNamespaces?.eip155?.chains ?? [];
    var chainStr = "";
    chains.forEachIndexed((index, element) {
      chainStr += index == 0 ? element : ", $element";
    });
    return chainStr;
  }

  String methodGenerate() {
    var method = prop.requiredNamespaces?.eip155?.methods ?? [];
    var methodStr = "";
    method.forEachIndexed((index, element) {
      methodStr += index == 0 ? element : ", $element";
    });
    return methodStr;
  }

  String eventGenerate() {
    var events = prop.requiredNamespaces?.eip155?.events ?? [];
    var eventStr = "";
    events.forEachIndexed((index, element) {
      eventStr += index == 0 ? element : ", $element";
    });
    return eventStr;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          "${prop.icons![0]}",
          width: 60,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NAME",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                "${prop.name}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CHAINS",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                "${chainsGenerate()}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "METHOD",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                "${methodGenerate()}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "EVENTS",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                "${eventGenerate()}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DESC",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                "${prop.description}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        )
      ],
    );
  }
}
