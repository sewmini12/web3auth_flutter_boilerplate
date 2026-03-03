import 'package:flutter/material.dart';
import 'package:web3auth_flutter/enums.dart';
import '../services/web3auth_service.dart';
import 'success_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _login(BuildContext context, Provider provider) async {
    try {
      await WalletService().init(); // <-- Add this line!
      final response = await WalletService().login(provider);
      if (!context.mounted) return;
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SuccessScreen(userInfo: response.userInfo?.toString()),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      final errorMsg = e.toString();
      if (errorMsg.contains('UserCancelledException')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login cancelled by user')),
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
      appBar: AppBar(title: const Text('Social Logins')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select a Login Method',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.g_mobiledata, size: 30),
              label: const Text('Login with Google'),
              onPressed: () => _login(context, Provider.google),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.facebook, size: 30),
              label: const Text('Login with Facebook'),
              onPressed: () => _login(context, Provider.facebook),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.alternate_email, size: 30),
              label: const Text('Login with Twitter'),
              onPressed: () => _login(context, Provider.twitter),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.apple, size: 30),
              label: const Text('Login with Apple'),
              onPressed: () => _login(context, Provider.apple),
            ),
          ],
        ),
      ),
    );
  }
}