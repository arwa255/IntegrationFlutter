class YieldModel {
  final double totalAmount;
  final double totalYield;

  YieldModel({
    required this.totalAmount,
    required this.totalYield,
  });

  // Factory constructor to create a YieldModel from JSON
  factory YieldModel.fromJson(Map<String, dynamic> json) {
    return YieldModel(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalYield: (json['totalYield'] as num).toDouble(),
    );
  }

  // Method to convert YieldModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'totalYield': totalYield,
    };
  }
}
