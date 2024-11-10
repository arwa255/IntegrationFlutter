const express = require('express');
const User = require('../models/user.js');
const bcrypt = require('bcryptjs');

const router = express.Router();

// Créer un utilisateur
router.post('/register', async (req, res) => {
  try {
    const { email, password, nationality, phone } = req.body;

    // Afficher les données reçues
    console.log('Received data:', req.body);

    // Créer un nouvel utilisateur
    const newUser = new User({ email, password, nationality, phone });

    // Enregistrer l'utilisateur dans la base de données
    const savedUser = await newUser.save();

    // Afficher l'utilisateur enregistré
    console.log('User registered:', savedUser);

    // Retourner une réponse
    res.status(201).json({ message: 'User registered successfully', user: savedUser });
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

// Authentifier un utilisateur
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // Vérifier si l'utilisateur existe
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    // Vérifier le mot de passe
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Email ou mot de passe incorrect' });
    }

    res.status(200).json({ message: 'Connexion réussie', user});
  } catch (error) {
    res.status(404).json({ message: 'Not Found', error });
  }
});

// Mettre à jour le mot de passe de l'utilisateur connecté
router.put('/update-password', async (req, res) => {
  const { email, newPassword } = req.body;

  try {
    // Trouver l'utilisateur par e-mail
    const user = await User.findOne({ email: email });

    if (!user) {
      return res.status(404).json({ message: "Utilisateur non trouvé" });
    }

    // Vous pouvez utiliser un hash pour le mot de passe avant de le sauvegarder
    // Assurez-vous d'utiliser une bibliothèque de hachage comme bcrypt
    user.password = newPassword; // Remplacez par user.password = await bcrypt.hash(newPassword, saltRounds); si vous utilisez bcrypt

    // Enregistrer les modifications
    const updatedUser = await user.save();

    res.status(200).json({ message: 'Mot de passe mis à jour avec succès', user: updatedUser });
  } catch (error) {
    console.error('Error updating password:', error);
    res.status(500).json({ message: 'Erreur du serveur', error });
  }
});


const nodemailer = require('nodemailer'); // ajouter en haut du fichier pour gérer l'envoi d'e-mails

// Envoyer un email pour le mot de passe oublié
router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "Utilisateur non trouvé" });
    }

    // Configurer le transporteur nodemailer
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'arwa.ali@esprit.tn',
        pass: 'prus lsth ocvx teuh',
      },
    });

    // Options de l'e-mail
    const mailOptions = {
      from: 'arwa.ali@esprit.tn',
      to: user.email,
      subject: 'Réinitialisation de mot de passe',
      text: 'Veuillez suivre ce lien pour réinitialiser votre mot de passe: [lien ici]',
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: 'Email de réinitialisation envoyé avec succès' });
  } catch (error) {
    console.error('Error sending email:', error);
    res.status(500).json({ message: 'Erreur du serveur', error });
  }
});


module.exports = router;