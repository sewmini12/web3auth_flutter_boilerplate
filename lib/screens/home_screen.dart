import 'package:flutter/material.dart';
import '../services/web3auth_service.dart';
import 'success_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _login(BuildContext context) async {
    try {
      await WalletService().init(); // <-- Add this line!
      final response = await WalletService().login();
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SuccessScreen(userInfo: response.userInfo?.toString()),
          ),
        );
      }
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('UserCancelledException')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login cancelled by user')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $errorMsg')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Connect with Web3'),
            ),
          ],
        ),
      ),
    );
  }
}