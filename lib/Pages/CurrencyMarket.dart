import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/CurrencyInfo.dart';
import 'package:flutter_app/Pages/CurrencyTracker.dart';

class CurrencyMarket extends StatefulWidget {

  CurrencyMarket({super.key});

  @override
  State<CurrencyMarket> createState() => _CurrencyMarketState();

}

class _CurrencyMarketState extends State<CurrencyMarket>{
  final List<CurrencyTracker> currencies = [];

  @override
  void initState() {
    currencies.add(CurrencyTracker("", "ETH", 9.2, 9.0));
    currencies.add(CurrencyTracker("", "BTC", 10.2, 10.7));
    currencies.add(CurrencyTracker("", "ETH", 8.5, 8.6));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212936),
      appBar: AppBar(
        title: const Text("Currency Market"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (BuildContext context, int index){
          for (var currency in currencies) {
            return CurrencyTracker(
                currencies[index].imageUrl,
                currencies[index].name,
                currencies[index].hourlyPrice,
                currencies[index].prevPrice);
            }
          },
        ),
      ),
    );

  }
}