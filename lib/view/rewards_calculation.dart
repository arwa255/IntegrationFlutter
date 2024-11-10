import 'package:flutter/material.dart';
import '../widget/reward_row.dart';

class RewardsCalculation extends StatefulWidget {
  final int totalBase;
  final int totalBonus;
  final int grandTotal;

  const RewardsCalculation({
    Key? key,
    required this.totalBase,
    required this.totalBonus,
    required this.grandTotal,
  }) : super(key: key);

  @override
  State<RewardsCalculation> createState() => _RewardsCalculationState();
}

class _RewardsCalculationState extends State<RewardsCalculation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rewards Calculation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 2, 43),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reward Breakdown',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 3, 90, 10),
              ),
            ),
            SizedBox(height: 20),
            // Using Card to display totals with elevation
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    RewardRow(label: 'Total Base', amount: widget.totalBase),
                    SizedBox(height: 10),
                    RewardRow(label: 'Total Bonus', amount: widget.totalBonus),
                    Divider(),
                    SizedBox(height: 10),
                    RewardRow(
                      label: 'Grand Total',
                      amount: widget.grandTotal,
                      isGrandTotal: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
