import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String? userInfo;
  const SuccessScreen({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Hello user, your login was successful!\n${userInfo ?? ""}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}