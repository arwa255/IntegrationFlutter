import 'package:flutter/material.dart';

class RewardRow extends StatelessWidget {
  final String label;
  final int amount;
  final bool isGrandTotal;

  const RewardRow({
    Key? key,
    required this.label,
    required this.amount,
    this.isGrandTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isGrandTotal ? 22 : 18,
            fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.normal,
            color: isGrandTotal ? Colors.green : Colors.black,
          ),
        ),
        Text(
          '\$${amount}',
          style: TextStyle(
            fontSize: isGrandTotal ? 22 : 18,
            fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.normal,
            color: isGrandTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
