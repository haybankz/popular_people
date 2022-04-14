import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(
      {Key? key, required this.errorMessage, required this.onRetry})
      : super(key: key);

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        Text(errorMessage),
        TextButton(
          child: const Text(
            "Click to retry",
            textAlign: TextAlign.center,
          ),
          onPressed: onRetry,
        )
      ],
    );
  }
}
