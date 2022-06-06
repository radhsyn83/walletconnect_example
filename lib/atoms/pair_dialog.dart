import 'package:flutter/material.dart';

class PairDialog extends StatefulWidget {
  const PairDialog({Key? key}) : super(key: key);

  @override
  State<PairDialog> createState() => _PairDialogState();
}

class _PairDialogState extends State<PairDialog> {
  late TextEditingController inputController;

  @override
  void initState() {
    inputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Pair"),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(hintText: "wc:..."),
        )
      ],
    );
  }
}
