const axios = require('axios');
const Analytics = require('../models/Analytics'); // MongoDB model

// Function to calculate sentiment score based on the closing prices
const calculateSentimentScore = (marketData) => {
  // Get the last 5 closing prices
  const closingPrices = marketData.slice(-5).map(data => parseFloat(data[4]));  // Binance API returns [timestamp, open, high, low, close, volume]
  
  if (closingPrices.length < 5) return 0; // Not enough data to calculate sentiment

  // Calculate the average closing price
  const avgClosingPrice = closingPrices.reduce((sum, price) => sum + price, 0) / closingPrices.length;

  // Compare the last closing price to the average
  const sentimentScore = (closingPrices[closingPrices.length - 1] - avgClosingPrice) / avgClosingPrice * 100;  // Percentage difference

  return sentimentScore; // This could be positive (bullish) or negative (bearish)
};

// Fetch data, generate analytics, and store in database
exports.getCryptoAnalytics = async (req, res) => {
  const crypto = req.params.crypto;

  try {
    // Fetch market data from Binance API
    const binanceResponse = await axios.get(`https://api.binance.com/api/v3/klines?symbol=${crypto}USDT&interval=1d`);
    const marketData = binanceResponse.data;

    // Check if analytics for this crypto already exist for today
    const existingAnalytics = await Analytics.findOne({ 
      crypto, 
      date: { $gte: new Date().setHours(0, 0, 0, 0) }  // Check if there's an entry for today
    });

    // If analytics exist, return the existing one
    if (existingAnalytics) {
      return res.status(200).json({
        message: "Analytics already exists for today",
        analytics: existingAnalytics
      });
    }

    // Calculate sentiment score based on the market data
    const sentimentScore = calculateSentimentScore(marketData);

    // Generate trend based on sentiment (basic logic)
    const trend = sentimentScore >= 0 ? "upward" : "downward";

    // Create analytics object
    const analytics = new Analytics({
      crypto,
      analysis: {
        sentimentScore,
        trend
      },
      marketData
    });

    // Save to database
    await analytics.save();

    res.status(200).json({
      message: "Analytics generated and saved successfully",
      analytics
    });
  } catch (error) {
    res.status(500).json({ message: 'Error generating analytics', error: error.message });
  }
};

