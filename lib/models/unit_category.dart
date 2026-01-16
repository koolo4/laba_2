import 'package:flutter/material.dart';
import 'unit.dart';

class UnitCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<Unit> units;
  final bool isTemperature;

  const UnitCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.units,
    this.isTemperature = false,
  });
}

class Categories {
  static const List<UnitCategory> all = [
    UnitCategory(
      name: 'Длина',
      icon: Icons.straighten,
      color: Colors.blue,
      units: [
        Unit(name: 'Миллиметр', symbol: 'мм', toBase: 0.001),
        Unit(name: 'Сантиметр', symbol: 'см', toBase: 0.01),
        Unit(name: 'Метр', symbol: 'м', toBase: 1.0),
        Unit(name: 'Километр', symbol: 'км', toBase: 1000.0),
        Unit(name: 'Дюйм', symbol: 'дюйм', toBase: 0.0254),
        Unit(name: 'Фут', symbol: 'фут', toBase: 0.3048),
        Unit(name: 'Ярд', symbol: 'ярд', toBase: 0.9144),
        Unit(name: 'Миля', symbol: 'миля', toBase: 1609.344),
      ],
    ),

    UnitCategory(
      name: 'Масса',
      icon: Icons.fitness_center,
      color: Colors.orange,
      units: [
        Unit(name: 'Миллиграмм', symbol: 'мг', toBase: 0.000001),
        Unit(name: 'Грамм', symbol: 'г', toBase: 0.001),
        Unit(name: 'Килограмм', symbol: 'кг', toBase: 1.0),
        Unit(name: 'Тонна', symbol: 'т', toBase: 1000.0),
        Unit(name: 'Унция', symbol: 'унц', toBase: 0.0283495),
        Unit(name: 'Фунт', symbol: 'фунт', toBase: 0.453592),
      ],
    ),


    UnitCategory(
      name: 'Температура',
      icon: Icons.thermostat,
      color: Colors.red,
      isTemperature: true,
      units: [
        Unit(name: 'Цельсий', symbol: '°C', toBase: 1.0),
        Unit(name: 'Фаренгейт', symbol: '°F', toBase: 1.0),
        Unit(name: 'Кельвин', symbol: 'K', toBase: 1.0),
      ],
    ),

    UnitCategory(
      name: 'Площадь',
      icon: Icons.crop_square,
      color: Colors.green,
      units: [
        Unit(name: 'Кв. миллиметр', symbol: 'мм²', toBase: 0.000001),
        Unit(name: 'Кв. сантиметр', symbol: 'см²', toBase: 0.0001),
        Unit(name: 'Кв. метр', symbol: 'м²', toBase: 1.0),
        Unit(name: 'Кв. километр', symbol: 'км²', toBase: 1000000.0),
        Unit(name: 'Гектар', symbol: 'га', toBase: 10000.0),
        Unit(name: 'Акр', symbol: 'акр', toBase: 4046.86),
      ],
    ),

    UnitCategory(
      name: 'Объём',
      icon: Icons.local_drink,
      color: Colors.purple,
      units: [
        Unit(name: 'Миллилитр', symbol: 'мл', toBase: 0.001),
        Unit(name: 'Литр', symbol: 'л', toBase: 1.0),
        Unit(name: 'Куб. метр', symbol: 'м³', toBase: 1000.0),
        Unit(name: 'Галлон (США)', symbol: 'гал', toBase: 3.78541),
        Unit(name: 'Пинта (США)', symbol: 'пинта', toBase: 0.473176),
      ],
    ),

    UnitCategory(
      name: 'Скорость',
      icon: Icons.speed,
      color: Colors.teal,
      units: [
        Unit(name: 'Метр/сек', symbol: 'м/с', toBase: 1.0),
        Unit(name: 'Км/час', symbol: 'км/ч', toBase: 0.277778),
        Unit(name: 'Миля/час', symbol: 'миля/ч', toBase: 0.44704),
        Unit(name: 'Узел', symbol: 'уз', toBase: 0.514444),
      ],
    ),

    UnitCategory(
      name: 'Время',
      icon: Icons.access_time,
      color: Colors.indigo,
      units: [
        Unit(name: 'Миллисекунда', symbol: 'мс', toBase: 0.001),
        Unit(name: 'Секунда', symbol: 'с', toBase: 1.0),
        Unit(name: 'Минута', symbol: 'мин', toBase: 60.0),
        Unit(name: 'Час', symbol: 'ч', toBase: 3600.0),
        Unit(name: 'День', symbol: 'д', toBase: 86400.0),
        Unit(name: 'Неделя', symbol: 'нед', toBase: 604800.0),
      ],
    ),

    UnitCategory(
      name: 'Данные',
      icon: Icons.storage,
      color: Colors.brown,
      units: [
        Unit(name: 'Бит', symbol: 'бит', toBase: 0.125),
        Unit(name: 'Байт', symbol: 'Б', toBase: 1.0),
        Unit(name: 'Килобайт', symbol: 'КБ', toBase: 1024.0),
        Unit(name: 'Мегабайт', symbol: 'МБ', toBase: 1048576.0),
        Unit(name: 'Гигабайт', symbol: 'ГБ', toBase: 1073741824.0),
        Unit(name: 'Терабайт', symbol: 'ТБ', toBase: 1099511627776.0),
      ],
    ),
  ];
}
