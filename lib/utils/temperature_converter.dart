class TemperatureConverter {

  static double convert(double value, String fromSymbol, String toSymbol) {
    if (fromSymbol == toSymbol) return value;

    double celsius;
    switch (fromSymbol) {
      case '°C':
        celsius = value;
        break;
      case '°F':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'K':
        celsius = value - 273.15;
        break;
      default:
        return value;
    }

    switch (toSymbol) {
      case '°C':
        return celsius;
      case '°F':
        return celsius * 9 / 5 + 32;
      case 'K':
        return celsius + 273.15;
      default:
        return value;
    }
  }

  static String? validateTemperature(double value, String symbol) {
    switch (symbol) {
      case 'K':
        if (value < 0) {
          return 'Температура не может быть ниже абсолютного нуля (0 K)';
        }
        break;
      case '°C':
        if (value < -273.15) {
          return 'Температура не может быть ниже абсолютного нуля (-273.15 °C)';
        }
        break;
      case '°F':
        if (value < -459.67) {
          return 'Температура не может быть ниже абсолютного нуля (-459.67 °F)';
        }
        break;
    }
    return null;
  }
}
