import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/navbar.dart';
import 'package:flutter_app/viewModel/rewards_viewModel.dart';
import 'package:flutter_app/viewModel/stak_viewmodel.dart';
import 'package:flutter_app/Pages/login_scene.dart'; // Adjust as per actual path
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RewardsViewmodel()),
        ChangeNotifierProvider(create: (context) => StakViewmodel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blockera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        future: _checkUserSession(),
        builder: (context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data != null) {
              // Si un userId est trouvé, afficher la page principale avec la navbar
              return NavbarPage(userId: snapshot.data!);
            } else {
              // Sinon, rediriger vers l'écran de connexion
              return Login();
            }
          }
        },
      ),
    );
  }

  // Function to check for a user session
  Future<String?> _checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Retourne l'userId si trouvé, sinon null
  }
}
