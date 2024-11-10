import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/wallet.dart';
import 'package:flutter_app/Pages/CurrencyMarket.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/Pages/Orderbook.dart';

class MyWalletPage extends StatefulWidget {
  final String userId; // Declare userId in the OrderBook class

  const MyWalletPage({Key? key, required this.userId}) : super(key: key);

  @override
  _MyWalletPageState createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  final String userId = '672a503e47820b5b13d91e6b'; // Replace with dynamic userId if needed
  String id = '';
  String owner = 'Awaiting Data';
  double balance = 0.0;
  double eth = 0.0;
  double btc = 0.0;
  double ltc = 0.0;
  String currency = 'N/A';
  bool isLoading = true;
  bool isFound = false;

  @override
  void initState() {
    super.initState();

    fetchWalletData(widget.userId);
  }

   void fetchWalletData(String identifier) async {
    final baseUrl = 'http://10.10.0.138:3000'; // Load base URL from .env
    final String url = '$baseUrl/api/wallet/$identifier';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          id = data['_id'];
          owner = data['userId'].substring(0, 10);
          balance = (data['balance'] as num).toDouble();
          ltc = (data['ltc'] as num).toDouble();
          btc = (data['btc'] as num).toDouble();
          eth = (data['eth'] as num).toDouble();
          currency = data['currency'];
          isFound = true;
          isLoading = false;
        });
      } else {
        print("Failed to load wallet data. Status code: ${response.statusCode}");
        if (response.statusCode == 404) {
          owner = "Not Found";
          isLoading = false;
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching wallet data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void createWallet() async {
    final baseUrl = 'http://10.10.0.138:3000'; // Load base URL from .env
    final String url = '$baseUrl/api/wallet/create';
    final Map<String, dynamic> walletData = {
      'userId': widget.userId,
      'balance': 300.0,
      'ETH': 0.0,
      'BTC': 0.0,
      'LTC': 0.0,
      'currency': 'USD',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(walletData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          id = data['_id'];
          owner = data['userId'].substring(0, 10);
          balance = (data['balance'] as num).toDouble();
          ltc = (data['ltc'] as num).toDouble();
          btc = (data['btc'] as num).toDouble();
          eth = (data['eth'] as num).toDouble();
          currency = data['currency'];
          isFound = true;
          isLoading = false;
        });
        print("Wallet created successfully.");
      } else {
        print("Failed to create wallet. Status code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error creating wallet: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212936),
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isFound
          ? Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInfoRow("Owner:", owner),
              const SizedBox(height: 20),
              buildInfoRow("Balance:", "$balance $currency"),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[900]
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[700], // Set grey background color here
                        borderRadius: BorderRadius.circular(15), // Set rounded corners here
                      ),
                      height: 5,
                    ),
                    buildInfoRow("Bitcoins:", "$btc"),
                    const SizedBox(height: 20),
                    buildInfoRow("Ethereum:", "$eth"),
                    const SizedBox(height: 20),
                    buildInfoRow("Litecoin:", "$ltc"),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[700], // Set grey background color here
                        borderRadius: BorderRadius.circular(60), // Set rounded corners here
                      ),
                      height: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildInfoRow("Currency:", currency),
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CurrencyMarket()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB1E457),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'See Currency Market',
                        style: TextStyle(
                            fontSize: 18, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderBook(userId: widget.userId, walletId: id)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB1E457),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'See Order Book',
                        style: TextStyle(
                            fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              Text(
                "User: ${widget.userId}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "No wallet found for this user, would you like to create one?",
                style:
                TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: createWallet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB1E457),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  'New Wallet...',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String data) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFFB1E457),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            data,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
