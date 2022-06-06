import 'package:flutter/material.dart';
import 'package:walletconnect/model/request_model.dart';

class RequestDialog extends StatelessWidget {
  final RequestModel req;
  const RequestDialog({Key? key, required this.req}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "REQUEST",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Image.network(
          "${req.peerMetaData?.icons![0]}",
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
                "${req.peerMetaData?.name}",
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
                "${req.chainId}",
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
                "${req.request?.method}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        // SizedBox(height: 15),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       "PARAMS",
        //       style: TextStyle(fontSize: 13, color: Colors.grey),
        //     ),
        //     SizedBox(width: 30),
        //     Expanded(
        //       child: Text(
        //         "${req.request?.params}",
        //         textAlign: TextAlign.right,
        //         style: TextStyle(fontSize: 14),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
