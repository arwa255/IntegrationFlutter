const express = require('express');
const Wallet = require('../models/wallet');
const router = express.Router();

// Create a wallet
router.post('/create', async (req, res) => {
  try {
    const { userId, balance, currency } = req.body;
    const wallet = await Wallet.create({ userId, balance, currency });
    res.status(201).json(wallet);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get wallet by user ID
router.get('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const wallet = await Wallet.findOne({ userId });
    if (!wallet) return res.status(404).json({ message: 'Wallet not found' });
    res.json(wallet);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update wallet balance (Deposit or Withdraw)
router.put('/update-balance/:walletId', async (req, res) => {
  try {
    const { walletId } = req.params;
    const { amount, transactionType } = req.body;

    // Find the wallet
    const wallet = await Wallet.findById(walletId);
    if (!wallet) return res.status(404).json({ message: 'Wallet not found' });

    // Update balance and transaction history
    if (transactionType === 'deposit') {
      wallet.balance += amount;
    } else if (transactionType === 'withdrawal') {
      if (wallet.balance < amount) return res.status(400).json({ message: 'Insufficient balance' });
      wallet.balance -= amount;
    } else {
      return res.status(400).json({ message: 'Invalid transaction type' });
    }

    wallet.transactions.push({ amount, type: transactionType });
    await wallet.save();
    res.json(wallet);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Delete wallet
router.delete('/:walletId', async (req, res) => {
  try {
    const { walletId } = req.params;
    await Wallet.findByIdAndDelete(walletId);
    res.json({ message: 'Wallet deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;