import 'package:flutter/material.dart';
import 'login_scene.dart'; // Assurez-vous que ce chemin correspond à l'emplacement de votre fichier login.dart

void main() {
  runApp(MyApp());
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'), // Titre de l'écran
        ),
        body: Login(), // Définir le Login comme écran principal
      ),
    );
  }
}
