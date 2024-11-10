import 'dart:ffi';

class Wallet {
  final String id;
  final String userId;
  final String balance;
  final String currency;

  Wallet(this.id, this.userId, this.balance, this.currency);

  @override
  String toString() {
    return 'Wallet{imageUrl: $id, name: $userId, hourlyPrice: $balance, prevPrice: $currency}';
  }
}
