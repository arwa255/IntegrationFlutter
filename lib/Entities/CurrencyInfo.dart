import 'dart:ffi';

class CurrencyInfo {
  final String imageUrl;
  final String name;
  final double hourlyPrice;
  final double prevPrice;

  CurrencyInfo(this.imageUrl, this.name, this.hourlyPrice, this.prevPrice);

  @override
  String toString() {
    return 'CurrencyInfo{imageUrl: $imageUrl, name: $name, hourlyPrice: $hourlyPrice, prevPrice: $prevPrice}';
  }
}
