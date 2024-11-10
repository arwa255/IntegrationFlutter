import 'package:flutter_app/view/rewards_calculation.dart';
import 'package:flutter_app/view/staking_options.dart';
import 'package:flutter_app/view/yield_tracking.dart';
import 'package:flutter_app/viewModel/rewards_viewModel.dart';
import 'package:flutter/material.dart';
import '../widget/gradient_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final rewardsViewModel = Provider.of<RewardsViewmodel>(context, listen: false);
    rewardsViewModel.loadTotalRewards();
  }

  @override
  Widget build(BuildContext context) {
    final rewardsViewModel = Provider.of<RewardsViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Staking & Rewards',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF001F54), // Dark blue color
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                Text(
                  '${rewardsViewModel.totalRewards?.grandTotal ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RewardsCalculation(
                          totalBase: (rewardsViewModel.totalRewards?.totalBase ?? 0).toInt(),
                          totalBonus: (rewardsViewModel.totalRewards?.totalBonus ?? 0).toInt(),
                          grandTotal: (rewardsViewModel.totalRewards?.grandTotal ?? 0).toInt(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF001B3A), // Darker blue background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/blockera.png',
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GradientButton(
                text: 'Staking Options',
                colors: [Colors.green[400]!, Colors.green[700]!], // Green gradient
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StakingOptions(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              GradientButton(
                text: 'Yield Tracking',
                colors: [const Color.fromARGB(255, 12, 114, 17)!, const Color.fromARGB(255, 5, 49, 7)!], // Green gradient
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YieldTrackingScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
