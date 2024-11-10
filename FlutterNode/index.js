const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(morgan('combined')); // Ajoutez un middleware de log

mongoose.connect('mongodb://localhost:27017/backmobile', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('Connected to MongoDB');
}).catch(err => {
  console.error('Error connecting to MongoDB:', err);
});

const userRoutes = require('./routes/userRoutes');
app.use('/api/users', userRoutes);

const walletRoutes = require('./routes/walletRoutes');
app.use('/api/wallet', walletRoutes);

const orderRoutes = require('./routes/orderRoutes');
app.use('/api/order', orderRoutes);

const stakingRoutes = require('./routes/StakingRoute');
app.use("/staking", stakingRoutes);

app.use((err, req, res, next) => {
  console.error(`Error occurred during ${req.method} ${req.url}:`, err);
  res.status(500).json({ error: 'Internal Server Error' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Access the server at: http://localhost:${PORT}`);
});
