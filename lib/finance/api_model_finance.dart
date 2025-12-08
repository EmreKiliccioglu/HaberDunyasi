//Apiden gelen verinin double dönüşümü
double parseSafeDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    value = value.replaceAll(",", ".");
    if (value == "-" || value.trim().isEmpty) return 0.0;
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}
//Finans veri modeli finans için ortak yapı
class MarketItem {
  final String name;
  final double value1;
  final double value2;
  final String type;

  MarketItem({
    required this.name,
    required this.value1,
    required this.value2,
    required this.type,
  });

  //Apiden gelen JSON verisini çevirme
  factory MarketItem.fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'crypto':
        return MarketItem(
          name: json['name'] ?? '',
          value1: parseSafeDouble(json['price']),
          value2: parseSafeDouble(json['changeDay']),
          type: type,
        );

      case 'currency':
        return MarketItem(
          name: json['name'] ?? '',
          value1: parseSafeDouble(json['buying']),
          value2: parseSafeDouble(json['selling']),
          type: type,
        );

      case 'gold':
        return MarketItem(
          name: json['name'] ?? '',
          value1: parseSafeDouble(json['buying']),
          value2: parseSafeDouble(json['selling']),
          type: type,
        );

      case 'emtia':
        return MarketItem(
          name: json['text'] ?? '',
          value1: parseSafeDouble(json['selling']),
          value2: parseSafeDouble(json['rate']),
          type: type,
        );

      case 'converter':
        return MarketItem(
          name: json['name'] ?? '',
          value1: parseSafeDouble(json['buying']),
          value2: parseSafeDouble(json['selling']),
          type: type,
        );

      default:
        return MarketItem(
          name: json['name'] ?? '',
          value1: 0,
          value2: 0,
          type: type,
        );
    }
  }
}



