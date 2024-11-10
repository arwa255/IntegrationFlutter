const express = require('express');
const Order = require('../models/order');
const Wallet = require('../models/wallet');
const router = express.Router();

// Create a new order
router.post('/create', async (req, res) => {
  try {
    const { walletId, type, asset, amount, price, stopPrice, action } = req.body;

    const wallet = await Wallet.findById(walletId);
    if (!wallet) return res.status(404).json({ message: 'Wallet not found' });

    // Lock funds for buy orders
    if (action === 'buy') {
      const totalCost = amount * price;
      if (wallet.balance < totalCost) {
        return res.status(400).json({ message: 'Insufficient funds for this order' });
      }
      wallet.balance -= totalCost;
      wallet.lockedBalance += totalCost;
    }

    const order = await Order.create({ walletId, type, asset, amount, price, stopPrice, action });
    await wallet.save();

    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get all orders by wallet ID
router.get('/wallet/:walletId', async (req, res) => {
  try {
    const { walletId } = req.params;
    const orders = await Order.find({ walletId });
    if (!orders.length) return res.status(404).json({ message: 'No orders found for this wallet' });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update order status
router.put('/update-status/:orderId', async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status } = req.body;

    const order = await Order.findById(orderId);
    if (!order) return res.status(404).json({ message: 'Order not found' });

    // Ensure valid status change
    if (!['pending', 'completed', 'cancelled'].includes(status)) {
      return res.status(400).json({ message: 'Invalid status' });
    }

    order.status = status;

    const wallet = await Wallet.findById(order.walletId);

    if (status === 'completed') {
      order.completedAt = new Date();

      if (order.action === 'buy') {
        wallet[order.asset.toLowerCase()] += order.amount;
        wallet.lockedBalance -= order.amount * order.price;
      } else if (order.action === 'sell') {
        wallet[order.asset.toLowerCase()] -= order.amount;
        wallet.balance += order.amount * order.price;
      }

    } else if (status === 'cancelled') {
      // Refund locked funds for buy orders if cancelled
      if (order.action === 'buy') {
        wallet.balance += order.amount * order.price;
        wallet.lockedBalance -= order.amount * order.price;
      }
    }

    await wallet.save();
    await order.save();

    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Delete an order by ID
router.delete('/:orderId', async (req, res) => {
  try {
    const { orderId } = req.params;
    await Order.findByIdAndDelete(orderId);
    res.json({ message: 'Order deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
