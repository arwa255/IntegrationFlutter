const mongoose = require('mongoose');

const analyticsSchema = new mongoose.Schema({
  crypto: String,              // Cryptocurrency symbol (e.g., BTC, ETH)
  date: { type: Date, default: Date.now },
  analysis: {
    sentimentScore: Number,    // Randomly generated sentiment score for now
    trend: String,             // Trend analysis (e.g., "upward", "downward")
  },
  marketData: Array            // Raw market data from Binance
});

module.exports = mongoose.model('Analytics', analyticsSchema);
