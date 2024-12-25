import 'package:flutter/material.dart';

class InlineError extends StatelessWidget {
  final String? errorText;

  const InlineError({super.key, this.errorText});

  @override
  Widget build(BuildContext context) {
    return errorText != null
        ? Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 10.0),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
