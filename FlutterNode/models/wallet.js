const mongoose = require('mongoose');

const walletSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  balance: {
    type: Number,
    default: 0
  },
  eth: {
    type: Number,
    default: 0
  },
  btc: {
    type: Number,
    default: 0
  },
  ltc: {
    type: Number,
    default: 0
  },
  lockedBalance: { // To reserve funds for open orders
    type: Number,
    default: 0
  },
  currency: {
    type: String,
    required: true,
    enum: ['USD', 'EUR', 'TND']
  },
  transactions: [
    {
      amount: Number,
      type: { type: String, enum: ['deposit', 'withdrawal'] },
      date: { type: Date, default: Date.now },
      status: { type: String, enum: ['pending', 'completed', 'failed'], default: 'completed' }
    }
  ]
}, { timestamps: true });

const Wallet = mongoose.model('Wallet', walletSchema);
module.exports = Wallet;
