const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  walletId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Wallet',
    required: true
  },
  type: {
    type: String,
    required: true,
    enum: ['Market', 'Stop-Loss', 'Limit']
  },
  asset: {
    type: String,
    required: true,
    enum: ['BTC', 'ETH', 'LTC']
  },
  amount: {
    type: Number,
    required: true,
    min: 0
  },
  price: { // Target price for limit orders
    type: Number,
    required: function() {
      return this.type !== 'market';
    }
  },
  stopPrice: { // Target price for stop-loss orders
    type: Number,
    required: function() {
      return this.type === 'stop-loss';
    }
  },
  status: {
    type: String,
    enum: ['pending', 'completed', 'cancelled'],
    default: 'pending'
  },
  action: {
    type: String,
    required: true,
    enum: ['buy', 'sell']
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  completedAt: Date
}, { timestamps: true });

const Order = mongoose.model('Order', orderSchema);
module.exports = Order;
