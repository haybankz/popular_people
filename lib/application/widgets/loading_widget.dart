import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator.adaptive(),
        ),
        Text("Loading ......")
      ],
    );
  }
}
