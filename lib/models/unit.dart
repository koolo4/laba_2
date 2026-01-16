
class Unit {
  final String name;
  final String symbol;
  final double toBase; 

  const Unit({
    required this.name,
    required this.symbol,
    required this.toBase,
  });

  double convertTo(double value, Unit targetUnit) {

    double baseValue = value * toBase;
    return baseValue / targetUnit.toBase;
  }

  @override
  String toString() => '$name ($symbol)';
}
