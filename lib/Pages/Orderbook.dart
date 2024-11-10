import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OrderBook extends StatefulWidget {
  final String userId; // Declare userId in the OrderBook class
  final String walletId; // Declare userId in the OrderBook class

  const OrderBook({Key? key, required this.userId, required this.walletId}) : super(key: key);

  @override
  _OrderBookState createState() => _OrderBookState();
}
class _OrderBookState extends State<OrderBook> {
  bool isBuySelected = true;

  final List<Map<String, dynamic>> buyOrders= [];
  final List<Map<String, dynamic>> sellOrders= [];

  final Map<int, String> currencyMap = {
    1: 'BTC',
    2: 'ETH',
    3: 'LTC',
  };

  final Map<int, IconData> currencyIcons = {
    1: Icons.monetization_on, // Placeholder icon for BTC
    2: Icons.attach_money,    // Placeholder icon for ETH
    3: Icons.euro_symbol,     // Placeholder icon for LTC
  };

  @override
  void initState() {
    super.initState();
    // Log the walletId when the OrderBook is created
    print("OrderBook created with walletId: ${widget.walletId}");
    // Call fetchOrders to load orders when the widget is initialized
    fetchOrders();
  }

  // Method to save an order to the database
  Future<void> saveOrder({
    required String walletId,
    required String type,
    required String asset,
    required double amount,
    double? price,
    double? stopPrice,
    required String action,
  }) async {
    final baseUrl = 'http://10.10.0.138:3000'; // Load base URL from .env
    final String url = '$baseUrl/api/order/create';

    try {
      final Map<String, dynamic> requestBody = {
        'walletId': walletId,
        'type': type,
        'asset': asset,
        'amount': amount,
        'price': price,
        'stopPrice': stopPrice,
        'action': action,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        print('Order saved successfully: ${response.body}');
        fetchOrders();
      } else {
        final errorResponse = jsonDecode(response.body);
        print("Failed to save order: ${errorResponse['message']}");
      }
    } catch (e) {
      print("Error saving order: $e");
    }
  }

  void fetchOrders() async {
    final baseUrl = 'http://10.10.0.138:3000'; // Load base URL from .env
    final String url = '$baseUrl/api/order/wallet/${widget.walletId}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        buyOrders.clear();
        sellOrders.clear();

        for (var order in data) {
          if (order['action'] == 'buy') {
            buyOrders.add({
              'id': order['_id'],
              'price': order['price'],
              'volume': order['amount'],
            });
          } else if (order['action'] == 'sell') {
            sellOrders.add({
              'id': order['_id'],
              'price': order['price'],
              'volume': order['amount'],
            });
          }
        }

        setState(() {});
      } else {
        print("Failed to load orders. Status code: ${response.statusCode}");
        if (response.statusCode == 404) {
          print("Error 404: Orders not found.");
        }
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayedOrders = isBuySelected ? buyOrders : sellOrders;

    return Scaffold(
      backgroundColor: const Color(0xFF212936),
      appBar: AppBar(
        title: const Text("Order Book"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // ToggleButtons for Buy and Sell
          Center(
            child: ToggleButtons(
              isSelected: [isBuySelected, !isBuySelected],
              selectedColor: Colors.black,
              fillColor: Color(0xFFB1E457),
              borderRadius: BorderRadius.circular(10),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Buy Orders',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Sell Orders',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  isBuySelected = index == 0;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          // Display data table based on selected tab
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order', style: TextStyle(fontSize: 16, color: Colors.white))),
                  DataColumn(label: Text('Price', style: TextStyle(fontSize: 16, color: Colors.white))),
                  DataColumn(label: Text('Vol', style: TextStyle(fontSize: 16, color: Colors.white))),
                ],
                rows: displayedOrders
                    .map((order) => DataRow(cells: [
                  DataCell(Text(order['currency'].toString(), style: const TextStyle(color: Colors.white))),
                  DataCell(Text(order['price'].toString(), style: const TextStyle(color: Colors.white))),
                  DataCell(Text(order['volume'].toString(), style: const TextStyle(color: Colors.white))),
                ]))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Bottom buttons for new buy/sell orders
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showNewOrderModal(context, isBuyOrder: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB1E457),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      "New Buy Order",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showNewOrderModal(context, isBuyOrder: false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB1E457),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      "New Sell Order",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showNewOrderModal(BuildContext context, {required bool isBuyOrder}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFB1E457),
      builder: (BuildContext context) {
        int selectedCurrencyId = 1; // Default currency ID (e.g., BTC)
        String selectedOrderType = 'Market'; // Default to Market order type
        final TextEditingController volumeController = TextEditingController();
        final TextEditingController priceController = TextEditingController(); // For Limit and Stop-Loss
        final TextEditingController stopPriceController = TextEditingController(); // For Stop-Loss

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isBuyOrder ? "Create New Buy Order" : "Create New Sell Order",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212936)),
                  ),

                  const SizedBox(height: 16),

                  // Dropdown for selecting the order type
                  DropdownButtonFormField<String>(
                    value: selectedOrderType,
                    decoration: InputDecoration(labelText: 'Order Type'),
                    items: ['Market', 'Limit', 'Stop-Loss'].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        selectedOrderType = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Dropdown for selecting currency
                  DropdownButtonFormField<int>(
                    value: selectedCurrencyId,
                    decoration: InputDecoration(labelText: 'Currency'),
                    items: currencyMap.keys.map((int id) {
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(currencyMap[id]!),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setModalState(() {
                        selectedCurrencyId = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Volume input (always shown)
                  TextField(
                    controller: volumeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Volume'),
                  ),

                  const SizedBox(height: 16),

                  // Conditional fields based on order type
                  if (selectedOrderType == 'Limit' || selectedOrderType == 'Stop-Loss')
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Desired Price'),
                    ),

                  const SizedBox(height: 16),

                  if (selectedOrderType == 'Stop-Loss')
                    TextField(
                      controller: stopPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Stop Price'),
                    ),

                  const SizedBox(height: 16),

                  // Submit button
                  ElevatedButton(
                    onPressed: () {
                      if (widget.walletId.isEmpty || widget.walletId.length != 24) {
                        print("Invalid walletId format: ${widget.walletId}");
                        return;
                      }
                      // Gather order details from input fields
                      String orderType = selectedOrderType;
                      String asset = currencyMap[selectedCurrencyId]!; // Assuming asset is currency name
                      double volume = double.tryParse(volumeController.text) ?? 0;
                      double? price = selectedOrderType == 'Market' ? null : double.tryParse(priceController.text);
                      double? stopPrice = selectedOrderType == 'Stop-Loss' ? double.tryParse(stopPriceController.text) : null;

                      // Call the method to save the order
                      saveOrder(
                        walletId: widget.walletId,
                        type: orderType,
                        asset: asset,
                        amount: volume,
                        price: 1,
                        stopPrice: stopPrice,
                        action: isBuyOrder ? 'buy' : 'sell', // Use 'buy' or 'sell' based on the order type
                      );

                      Navigator.pop(context); // Close the modal after submission
                    },
                    child: const Text('Submit Order'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
