import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/EditAccount.dart';
import 'package:flutter_app/Pages/mywallet.dart';
import 'package:flutter_app/Pages/wallet.dart';

import 'package:flutter_app/view/home_screen.dart';

class NavbarPage extends StatefulWidget {
  final String userId;

  const NavbarPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NavbarPageState createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      EditAccount(),
      MyWalletPage(userId: widget.userId),
      Wallet(),
      HomeScreen(),
     // TradingPage(userId: widget.userId),
      //StakingPage(userId: widget.userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF212936),
        selectedItemColor: const Color(0xFFB1E457),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Prices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trading',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Staking',
          ),
        ],
      ),
    );
  }
}
