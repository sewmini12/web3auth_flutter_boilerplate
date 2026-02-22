import 'dart:io';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';

class WalletService {
  static final WalletService _instance = WalletService._internal();
  factory WalletService() => _instance;
  WalletService._internal();

  bool _initialized = false;

  /// Initialize Web3Auth
  Future<void> init() async {
    if (_initialized) return;

    late final Uri redirectUrl;

    if (Platform.isAndroid) {
      redirectUrl =
          Uri.parse('w3a://com.example.web3auth_flutter_boilerplate/auth'); // change package name
    } else {
      redirectUrl =
          Uri.parse('com.example.web3auth_flutter_boilerplate://auth'); // change bundle id
    }

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId: "BH9TdqxFxCVTZaaAaypyYGHjeuVVPGKfmLebi-TgTCm-kRyf0GM3EpZBWboLXVNj5GEnnnAS7EDNAhaqIw7yCyA",
        network: Network.sapphire_devnet, // devnet for testing
        redirectUrl: redirectUrl,
      ),
    );

    _initialized = true;
  }

  /// Restore existing session
  Future<bool> restoreSession() async {
    await Web3AuthFlutter.initialize();
    final privateKey = await Web3AuthFlutter.getPrivKey();
    return privateKey.isNotEmpty;
  }

  /// Login with Google (you can extend later)
  Future<Web3AuthResponse?> login() async {
    return await Web3AuthFlutter.login(
      LoginParams(loginProvider: Provider.google),
    );
  }

  /// Logout
  Future<void> logout() async {
    await Web3AuthFlutter.logout();
  }

  /// Get private key
  Future<String> getPrivateKey() async {
    return await Web3AuthFlutter.getPrivKey();
  }

  /// Android custom tabs handler
  void handleCustomTabs() {
    Web3AuthFlutter.setCustomTabsClosed();
  }
}