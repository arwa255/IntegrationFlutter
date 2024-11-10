import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/rewards_model.dart';
import '../model/yield_model.dart';
import '../services/apis.dart';

class RewardsViewmodel extends ChangeNotifier {
  final apiService = ApiService();
  TotalRewards? _totalRewards;
  String? _userId; // Changed to nullable

  TotalRewards? get totalRewards => _totalRewards;

  YieldModel? _totalYield;

  YieldModel? get totalYield => _totalYield;

  // Getter for userId
  String? get userId => _userId;

  // Method to initialize userId from SharedPreferences
  Future<void> initializeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  Future<void> loadTotalRewards() async {
    try {
      if (_userId == null) {
        await initializeUserId(); // Ensure userId is loaded
      }
      if (_userId != null) {
        _totalRewards = await apiService.fetchTotalRewards(_userId!);
        notifyListeners(); // Notify listeners about the state change
      } else {
        print('User ID is not available');
      }
    } catch (error) {
      print('Error loading total rewards: $error');
    }
  }

  Future<void> loadTotalYield() async {
    try {
      if (_userId == null) {
        await initializeUserId(); // Ensure userId is loaded
      }
      if (_userId != null) {
        _totalYield = await apiService.fetchYieldData(_userId!);
        notifyListeners();
      } else {
        print('User ID is not available');
      }
    } catch (error) {
      print('Error loading total yield: $error');
    }
  }
}
