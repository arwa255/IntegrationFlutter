import 'package:flutter/material.dart';

class CurrencyTracker extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double hourlyPrice;
  final double prevPrice;

  const CurrencyTracker(this.imageUrl, this.name, this.hourlyPrice, this.prevPrice, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            width: 50,
            margin: const EdgeInsets.all(8.0),
            child: Image.asset(
              imageUrl,
              width: 100,
              height: 100,
            ),
          ),

          const SizedBox(width: 40),

          Expanded( // Expanded to fill available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display the hourly price
                    Text(
                      "$hourlyPrice",
                      textScaleFactor: 1.5,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // Add some spacing
                    const SizedBox(width: 20),

                    // Display up or down arrow depending on price comparison
                    Image.asset(
                      hourlyPrice < prevPrice
                          ? 'assets/images/Green_Arrow_Up.png'   // Path to your up arrow image
                          : 'assets/images/Red_Arrow_Down.svg.png', // Path to your down arrow image
                      width: 20,
                      height: 20,
                    ),

                    // Add some spacing
                    const SizedBox(width: 20),

                    // Display the previous price
                    Text(
                      "$prevPrice",
                      textScaleFactor: 1.5,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Spacer to push the button to the right
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB1E457)),
            child: const Text("Place Order", style: TextStyle(color: Colors.black),),
          ),

          const SizedBox(width: 20), // Optional space between button and card's right edge
        ],
      ),
    );
  }
}
