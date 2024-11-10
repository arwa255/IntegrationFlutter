import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

bool _isLoading = true;  // Start with true for loading state
class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key}) : super(key: key);

  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  bool _darkMode = true;
  bool _showAverage = false;

  String _selectedCrypto = 'BTC';
  List<String> _cryptoList = ['BTC', 'ETH', 'BNB'];

  List<dynamic> _chartData = [];
  List<CandleData> _candleData = [];

  // To hold the analytics data (sentiment score, trend)
  double? _sentimentScore;
  String? _trend;

  @override
  void initState() {
    super.initState();
    _fetchChartData(_selectedCrypto);
    _fetchAnalyticsData(_selectedCrypto);  // Fetch analytics when the page loads
  }

  // Function to fetch the chart data (candlestick data)
  Future<void> _fetchChartData(String crypto) async {
    final response = await http.get(
      Uri.parse('https://api.binance.com/api/v3/klines?symbol=${crypto}USDT&interval=1d'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _chartData = jsonDecode(response.body);
        _updateCandleData();
      });
    } else {
      throw Exception('Failed to load chart data');
    }
  }

  // Function to fetch the analytics data (sentiment score and trend)
  Future<void> _fetchAnalyticsData(String crypto) async {
    debugPrint('here');
    try {
      final response = await http.get(
        Uri.parse('http://10.10.0.138:3000/api/crypto/$crypto'),
      );

      if (response.statusCode == 200) {
        // Print the raw response body for debugging
        debugPrint('Raw Response: ${response.body}');
        var data = jsonDecode(response.body);

        // Check if the structure is as expected
        debugPrint('Decoded Response Data: $data');

        setState(() {
          _sentimentScore = data['analytics']['analysis']['sentimentScore'];
          _trend = data['analytics']['analysis']['trend'];
          _isLoading = false;
        });
      } else {
        print('Failed to load analytics data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  void _updateCandleData() {
    _candleData.clear();
    for (var item in _chartData) {
      double open = double.parse(item[1]);
      double high = double.parse(item[2]);
      double low = double.parse(item[3]);
      double close = double.parse(item[4]);
      double volume = double.parse(item[5]);
      int timestamp = item[0];
      _candleData.add(CandleData(
        timestamp: timestamp,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _darkMode ? Brightness.dark : Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Charts & Analytics"),
          actions: [
            IconButton(
              icon: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => setState(() => _darkMode = !_darkMode),
            ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: _selectedCrypto,
                  items: _cryptoList.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCrypto = newValue!;
                      _fetchChartData(_selectedCrypto);
                      _fetchAnalyticsData(_selectedCrypto);  // Fetch analytics for new crypto
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildChartSection(),
                SizedBox(height: 20),
                _buildAnalyticsSection(), // New Analytics Section
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the chart section (line chart and volume chart)
  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price Line Chart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 200,
          child: LineChart(_buildLineChartData()),
        ),
        SizedBox(height: 20),
        Text(
          "Trading Volume Bar Chart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 200,
          child: BarChart(_buildBarChartData()),
        ),
        SizedBox(height: 20),
        Text(
          "Interactive Chart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 300,
          child: InteractiveChart(candles: _candleData),
        ),
      ],
    );
  }

  // Builds the analytics section (sentiment score and trend)
  Widget _buildAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Analytics Data",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (_sentimentScore != null && _trend != null) ...[
          Card(
            color: Colors.blueAccent,
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Icon(Icons.sentiment_satisfied, color: Colors.white),
              title: Text(
                "Sentiment Score",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "${_sentimentScore!.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            color: Colors.greenAccent,
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Icon(Icons.trending_up, color: Colors.white),
              title: Text(
                "Trend",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _trend ?? "Loading...",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ] else if (_sentimentScore == null || _trend == null) ...[
          Center(child: CircularProgressIndicator()), // Show loading spinner if data is not available
        ]
      ],
    );
  }

  LineChartData _buildLineChartData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < _candleData.length; i++) {
      double? closePrice = _candleData[i].close;
      if (closePrice != null) {
        spots.add(FlSpot(i.toDouble(), closePrice));
      }
    }
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.black, width: 1)),
      minX: 0,
      maxX: _candleData.length.toDouble(),
      minY: _candleData.map((e) => e.low ?? 0).reduce((a, b) => a < b ? a : b),
      maxY: _candleData.map((e) => e.high ?? 0).reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 2,
          gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
        ),
      ],
    );
  }

  BarChartData _buildBarChartData() {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < _candleData.length; i++) {
      double? closePrice = _candleData[i].close;
      if (closePrice != null) {
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: closePrice,
                gradient: LinearGradient(colors: [Colors.green, Colors.lightGreen]),
              ),
            ],
          ),
        );
      }
    }
    return BarChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      barGroups: barGroups,
    );
  }
}
