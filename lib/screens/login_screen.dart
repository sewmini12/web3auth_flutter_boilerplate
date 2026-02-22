import 'package:flutter/material.dart';
import '../services/web3auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with WidgetsBindingObserver {
  final WalletService _walletService = WalletService();

  String _result = '';
  bool _isLoggedIn = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Required for Android custom tabs
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _walletService.handleCustomTabs();
    }
  }

  Future<void> _initialize() async {
    await _walletService.init();

    try {
      bool sessionExists = await _walletService.restoreSession();

      setState(() {
        _isLoggedIn = sessionExists;
        _result =
            sessionExists ? "Existing session found" : "No active session";
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = "Initialization error: $e";
        _loading = false;
      });
    }
  }

  Future<void> _login() async {
    try {
      final response = await _walletService.login();

      setState(() {
        _isLoggedIn = true;
        _result = response?.privKey ?? "Login successful";
      });
    } catch (e) {
      setState(() {
        _result = "Login error: $e";
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _walletService.logout();

      setState(() {
        _isLoggedIn = false;
        _result = "Logged out successfully";
      });
    } catch (e) {
      setState(() {
        _result = "Logout error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Web3Auth Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoggedIn ? null : _login,
              child: const Text("Login with Google"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoggedIn ? _logout : null,
              child: const Text("Logout"),
            ),
            const SizedBox(height: 30),
            Text(
              _result,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}