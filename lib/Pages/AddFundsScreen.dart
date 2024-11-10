import 'package:flutter/material.dart';


class AddFundsScreen extends StatelessWidget {
  final String currentCurrency = "USD"; // Placeholder for currency

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212936),
        title: Row(
          children: [
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Placeholder for changing currency
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              child: Text(
                '$currentCurrency',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF212936),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "I don't have crypto assets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildOption(
              title: "P2P Trading",
              description: "Buy from users. Competitive prices. Local payments",
            ),
            SizedBox(height: 20),
            Text(
              "I have crypto assets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildOption(
              title: "Deposit crypto",
              description: "Send crypto to your Binance Account",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({required String title, required String description}) {
    return InkWell(
      onTap: () {
        // Handle navigation or action for each option
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF39475B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.white, size: 40), // Placeholder icon
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
