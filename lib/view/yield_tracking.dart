import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/rewards_viewModel.dart';

class YieldTrackingScreen extends StatefulWidget {
  const YieldTrackingScreen({super.key});

  @override
  State<YieldTrackingScreen> createState() => _YieldTrackingScreenState();
}

class _YieldTrackingScreenState extends State<YieldTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RewardsViewmodel>(context, listen: false).loadTotalYield();
    });
  }

  @override
  Widget build(BuildContext context) {
    final yieldViewModel = Provider.of<RewardsViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 43, 9),
        title: Text(
          'Yield Tracking',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: yieldViewModel.totalYield == null
              ? CircularProgressIndicator(color: Colors.deepPurple)
              : Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 8, 75, 36), const Color.fromARGB(255, 1, 75, 26)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Yield Tracking',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Total Amount:',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                Text(
                  '\$${yieldViewModel.totalYield?.totalAmount ?? 0}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Total Yield:',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                Text(
                  '\$${yieldViewModel.totalYield?.totalYield ?? 0}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                LinearProgressIndicator(
                  value: (yieldViewModel.totalYield?.totalYield ?? 0) /
                      (yieldViewModel.totalYield?.totalAmount ?? 1),
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
