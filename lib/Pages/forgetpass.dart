import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/login_scene.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour décoder la réponse JSON

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

   Future<void> _sendResetLink() async {
    final email = _emailController.text;
    final baseUrl = 'http://10.10.0.138:3000'; // Load base URL from .env

    final url = '$baseUrl/api/users/forgot-password'; // Construct the complete URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Un lien de réinitialisation a été envoyé à votre e-mail.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi du lien. Veuillez réessayer.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau. Veuillez vérifier votre connexion.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // Récupérer la largeur et la hauteur de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF212936),
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Remplace par ton logo
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                // Champ Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color(0xFF6C727F),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Bouton pour envoyer le lien de réinitialisation
                ElevatedButton(
                  onPressed: _sendResetLink,
                  child: const Text('Send Reset Link'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB1E457),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 40),

                // Lien pour revenir à la page de connexion
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
