const express = require("express");
const { addStake, getStakes, calculateTotalRewards, getTotalAmountAndYield } = require("../controllers/StakingController.js");

const router = express.Router();

router.post("/add", addStake);
router.get("/:userId", getStakes);
router.get('/rewards/:userId', calculateTotalRewards);
router.get('/total/:userId', getTotalAmountAndYield);

module.exports = router;
