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
      appBar:AppBar(
        title: Text(
          'Staking & Rewards',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Display grand total in the AppBar
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                Text(
                  '${rewardsViewModel.totalRewards?.grandTotal ?? 0}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline),
                  color: Colors.white,
                  onPressed: () {
                    // Navigate to Rewards Screen with total rewards data
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
                      offset: Offset(0, 5),
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
              SizedBox(height: 30),
              // Using GradientButton for each action
              GradientButton(text: 'Staking Options', onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StakingOptions(),
                  ),
                );
              },
              ),
              SizedBox(height: 15),
              GradientButton(
                text: 'Yield Tracking',
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
