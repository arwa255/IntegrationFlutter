const StakingModel = require("../models/StakingModel.js");
const UserModel = require("../models/user.js");

// Add a staking entry
const addStake = async (req, res) => {
  const { userId, amount, duration } = req.body;

  try {
    const stake = new StakingModel({
      user: userId,
      amount: String(amount),
      duration,
      yield: calculateYield(Number(amount), duration),
      rewards: calculateRewards(Number(amount), duration)
    });
    await stake.save();

    await UserModel.findByIdAndUpdate(userId, { $push: { stakes: stake._id } });
    res.status(201).json(stake);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Calculate yield
const calculateYield = (amount, duration) => {
  const baseYieldRates = { "1 month": 0.02, "3 months": 0.06, "6 months": 0.12 };
  return amount * (baseYieldRates[duration] || 0); // Return as a number
};

// Calculate rewards with base and bonus
const calculateRewards = (amount, duration) => {
  const baseReward = calculateYield(amount, duration); // Keep this as a number
  const bonusRate = duration === "6 months" ? 0.05 : 0.02;
  return {
    base: baseReward, // Return as a number
    bonus: amount * bonusRate // Return as a number
  };
};

// Fetch staking data
const getStakes = async (req, res) => {
  const { userId } = req.params;

  try {
    const stakes = await StakingModel.find({ user: userId });
    res.status(200).json(stakes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Function to calculate total rewards for a user
const calculateTotalRewards = async (req, res) => {
  const { userId } = req.params;

  try {
    const stakes = await StakingModel.find({ user: userId });

    let totalBase = 0;
    let totalBonus = 0;

    stakes.forEach(stake => {
      totalBase += Number(stake.rewards.base);
      totalBonus += Number(stake.rewards.bonus);
    });

    // Prepare the total rewards
    const totalRewards = {
      totalBase,
      totalBonus,
      grandTotal: totalBase + totalBonus
    };

    res.status(200).json(totalRewards);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get total amount and yield
const getTotalAmountAndYield = async (req, res) => {
  const { userId } = req.params; // User ID from route parameters

  try {
    // Fetch all staking records for the user
    const stakes = await StakingModel.find({ user: userId });

    // Calculate total amount and yield
    const totalAmount = stakes.reduce((acc, stake) => acc + parseFloat(stake.amount), 0);
    const totalYield = stakes.reduce((acc, stake) => acc + parseFloat(stake.yield), 0);

    // Respond with the calculated values
    res.status(200).json({
      totalAmount,
      totalYield,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Export functions
module.exports = {
  addStake,
  getStakes,
  calculateTotalRewards,
  getTotalAmountAndYield
};
