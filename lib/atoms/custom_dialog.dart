import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final Function onApprove;
  final Function onReject;
  final bool isPair;

  const CustomDialog(
      {Key? key,
      required this.child,
      required this.onApprove,
      required this.onReject,
      this.isPair = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: child,
      actions: [
        TextButton(
          onPressed: () => onReject(),
          child: Text(isPair ? 'close' : 'Reject',
              style: TextStyle(
                color: Colors.red,
              )),
        ),
        TextButton(
          onPressed: () => onApprove(),
          child: Text(
            isPair ? 'Pair' : 'Approve',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
