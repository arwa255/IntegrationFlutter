import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/AddFundsScreen.dart';
import 'package:flutter_app/Pages/BuyScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  double totalBalance = 0.0;
  bool isLoading = true;

  String selectedCurrency = 'USD';
  String? userId; // Declare userId
  List<Map<String, dynamic>> currencies = [];

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchWalletData();
  }

  Future<void> _loadUserIdAndFetchWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId'); // Fetch userId from SharedPreferences

    if (userId != null) {
      await fetchWalletData(userId!);
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found. Please log in again.')),
      );
    }
  }

  Future<void> fetchWalletData(String identifier) async {
    final baseUrl = 'http://10.10.0.138:3000'; // Use dotenv for environment variables
    final String url = '$baseUrl/api/wallet/$identifier';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalBalance = (data['balance'] as num).toDouble();
          currencies = [
            {'name': 'BTC', 'price': 60000, 'amount': (data['btc'] as num).toDouble()},
            {'name': 'ETH', 'price': 3000, 'amount': (data['eth'] as num).toDouble()},
            {'name': 'BNB', 'price': 250, 'amount': 0.0},
            {'name': 'USDT', 'price': 1, 'amount': 0.0},
            {'name': 'USD', 'price': 1.0, 'amount': totalBalance},
          ];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load wallet data.')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching wallet data: $e')),
      );
    }
  }

  void _navigateToAddFunds() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFundsScreen()),
    );
  }

  void _navigateToBuy(String currencyName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuyScreen(currencyName: currencyName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        backgroundColor: const Color(0xFF212936),
      ),
      backgroundColor: const Color(0xFF212936),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        selectedCurrency == 'USD'
                            ? '\$${totalBalance.toStringAsFixed(2)}'
                            : '${currencies.firstWhere((c) => c['name'] == selectedCurrency)['amount'].toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedCurrency,
                        onChanged: (String? newCurrency) {
                          setState(() {
                            selectedCurrency = newCurrency!;
                          });
                        },
                        dropdownColor: const Color(0xFF39475B),
                        style: TextStyle(color: Colors.white),
                        items: currencies.map<DropdownMenuItem<String>>((currency) {
                          return DropdownMenuItem<String>(
                            value: currency['name'],
                            child: Text(currency['name']),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  if (selectedCurrency != 'USD')
                    Text(
                      '≈ \$${(currencies.firstWhere((c) => c['name'] == selectedCurrency)['amount'] * currencies.firstWhere((c) => c['name'] == selectedCurrency)['price']).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _navigateToAddFunds,
                    child: Text(
                      'Add Funds',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB1E457),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currencies.length,
                      itemBuilder: (context, index) {
                        final currency = currencies[index];
                        return Card(
                          color: const Color(0xFF39475B),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            title: Text(
                              currency['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Price: \$${currency['price'].toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: TextButton(
                              onPressed: () => _navigateToBuy(currency['name']),
                              child: Text(
                                'Buy Now',
                                style: TextStyle(color: const Color(0xFFB1E457)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
