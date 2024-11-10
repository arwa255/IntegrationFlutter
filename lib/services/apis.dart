import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import '../model/rewards_model.dart';
import '../model/yield_model.dart';

class ApiService {
    final baseUrl = 'http://10.10.0.138:3000'; // Load base URL from .env

  Future<TotalRewards?> fetchTotalRewards(String userId) async {
    final url = Uri.parse('$baseUrl/staking/rewards/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return TotalRewards.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load total rewards');
      }
    } catch (error) {
      print('Error fetching total rewards: $error');
      return null;
    }
  }

  Future<http.Response?> addStake(String userId, double amount, String duration) async {
    final url = Uri.parse('$baseUrl/staking/add');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'amount': amount,
          'duration': duration,
        }),
      );

      return response; // Return the response
    } catch (error) {
      print('Error adding stake: $error');
      return null; // Return null on error
    }
  }

  Future<YieldModel> fetchYieldData(String userId) async {
    final url = Uri.parse('$baseUrl/staking/total/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return YieldModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load yield data');
      }
    } catch (error) {
      print('Error fetching yield data: $error');
      throw Exception('Failed to fetch yield data');
    }
  }
}
