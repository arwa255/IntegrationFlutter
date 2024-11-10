import 'dart:ffi';

class Order {
  final String walletId;
  final String type;
  final String asset;
  final String amount;
  final String price;
  final String stopPrice;
  final String status;
  final String action;

  Order(this.walletId, this.type, this.asset, this.amount, this.price, this.stopPrice, this.status, this.action);

  @override
  String toString() {
    return 'Wallet{imageUrl: $walletId, name: $type, hourlyPrice: $asset, prevPrice: $amount, price: $price, stopPrice: $stopPrice, action: $action}';
  }
}
