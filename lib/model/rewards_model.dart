class TotalRewards {
  final double totalBase;
  final double totalBonus;
  final double grandTotal;

  TotalRewards({
    required this.totalBase,
    required this.totalBonus,
    required this.grandTotal,
  });

  // Factory method to create a TotalRewards instance from JSON
  factory TotalRewards.fromJson(Map<String, dynamic> json) {
    return TotalRewards(
      totalBase: json['totalBase'].toDouble(),
      totalBonus: json['totalBonus'].toDouble(),
      grandTotal: json['grandTotal'].toDouble(),
    );
  }

  // Method to convert TotalRewards instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalBase': totalBase,
      'totalBonus': totalBonus,
      'grandTotal': grandTotal,
    };
  }
}
