import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/apis.dart';

class StakViewmodel extends ChangeNotifier {
  final apiService = ApiService();

  String _message = '';
  bool _isSuccess = false;

  String? _userId; // Changed to nullable

  String get message => _message;
  bool get isSuccess => _isSuccess;

  // Getter for userId
  String? get userId => _userId;

  // Method to initialize userId from SharedPreferences
  Future<void> initializeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  Future<void> addStake(double amount, String duration) async {
    try {
      if (_userId == null) {
        await initializeUserId(); // Ensure userId is loaded
      }

      if (_userId != null) {
        final response = await apiService.addStake(_userId!, amount, duration);

        if (response != null) {
          if (response.statusCode == 201) {
            _isSuccess = true;
            _message = 'Stake added successfully!';
          } else {
            _isSuccess = false;
            _message = 'Failed to add stake';
          }
        } else {
          _isSuccess = false;
          _message = 'No response from the server';
        }
      } else {
        _isSuccess = false;
        _message = 'User ID is not available';
      }
    } catch (error) {
      _isSuccess = false;
      _message = 'Error: $error';
    }

    notifyListeners();
  }
}
