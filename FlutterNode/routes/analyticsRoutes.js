const express = require('express');
const router = express.Router();
const analyticsController = require('../controllers/AnalyticsController');

// Route to generate and store analytics for a cryptocurrency
router.get('/:crypto', analyticsController.getCryptoAnalytics);

module.exports = router;
