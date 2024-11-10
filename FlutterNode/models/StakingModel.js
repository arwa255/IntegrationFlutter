const mongoose = require("mongoose");

const { Schema, model } = mongoose;

const stakingSchema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  amount: {
    type: String, 
    required: true
  },
  duration: {
    type: String, 
    required: true
  },
  yield: {
    type: String,
    default: "0"
  },
  rewards: {
    base: { type: String, default: "0" }, 
    bonus: { type: String, default: "0" } 
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const StakingModel = model("Staking", stakingSchema);

module.exports = StakingModel;
