import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/stak_viewmodel.dart';

class StakingOptions extends StatefulWidget {
  const StakingOptions({super.key});

  @override
  State<StakingOptions> createState() => _StakingOptionsState();
}

class _StakingOptionsState extends State<StakingOptions> {
  String? _selectedDuration;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stakingViewModel = Provider.of<StakViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Staking Options',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 44, 5),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Staking Duration',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedDuration,
                  items: <String>['1 Month', '3 Months', '6 Months'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black), // Set text color to black
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDuration = value;
                    });
                  },
                  hint: Text('Choose Duration', style: TextStyle(color: Colors.black)),
                  isExpanded: true, // Make the dropdown take the full width
                  style: TextStyle(fontSize: 18, color: Colors.black), // Set selected text color to black
                  underline: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  iconEnabledColor: Colors.black, // Change the dropdown icon color to black
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Amount to Stake',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedDuration != null && _amountController.text.isNotEmpty) {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(child: CircularProgressIndicator());
                        },
                      );

                      double amount = double.tryParse(_amountController.text) ?? 0.0;

                      if (amount > 0) {
                        // Call the addStake function from the view model
                        await stakingViewModel.addStake(amount, _selectedDuration!);
                      } else {
                        Navigator.of(context).pop(); // Dismiss loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a valid amount.'),
                            backgroundColor: const Color.fromARGB(255, 3, 151, 3),
                          ),
                        );
                        return;
                      }

                      // Dismiss loading indicator
                      Navigator.of(context).pop();

                      // Show success or error message
                      final snackBar = SnackBar(
                        content: Text(stakingViewModel.message),
                        backgroundColor: stakingViewModel.isSuccess ? Colors.green : Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      // Navigate back to the HomeScreen if staking is successful
                      if (stakingViewModel.isSuccess) {
                        Navigator.pop(context); // Pop the StakingOptions screen
                      }
                    } else {
                      // Show an error if fields are empty
                      final snackBar = SnackBar(
                        content: Text('Please select a duration and enter an amount.'),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 18, 141, 7),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    'Confirm Stake',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
