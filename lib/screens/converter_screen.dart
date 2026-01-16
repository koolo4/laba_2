import 'package:flutter/material.dart';
import '../models/unit_category.dart';
import '../models/unit.dart';
import '../widgets/numeric_keypad.dart';
import '../utils/temperature_converter.dart';
import '../main.dart';

class ConverterScreen extends StatefulWidget {
  final UnitCategory category;

  const ConverterScreen({super.key, required this.category});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  late Unit _fromUnit;
  late Unit _toUnit;
  String _inputValue = '0';
  String _outputValue = '0';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fromUnit = widget.category.units[0];
    _toUnit = widget.category.units.length > 1
        ? widget.category.units[1]
        : widget.category.units[0];
    _convert();
  }

  void _convert() {
    setState(() {
      _errorMessage = null;

      if (_inputValue.isEmpty || _inputValue == '-') {
        _inputValue = '0';
      }

      double? inputDouble = double.tryParse(_inputValue);
      if (inputDouble == null) {
        _errorMessage = 'Некорректное значение';
        _outputValue = 'Ошибка';
        return;
      }

      if (inputDouble.abs() > 1e15) {
        _errorMessage = 'Число слишком большое';
        _outputValue = 'Ошибка';
        return;
      }

      double result;

      if (widget.category.isTemperature) {

        String? validationError =
            TemperatureConverter.validateTemperature(inputDouble, _fromUnit.symbol);
        if (validationError != null) {
          _errorMessage = validationError;
          _outputValue = 'Ошибка';
          return;
        }

        result = TemperatureConverter.convert(
          inputDouble,
          _fromUnit.symbol,
          _toUnit.symbol,
        );
      } else {

        if (inputDouble < 0 && _shouldBePositive()) {
          _errorMessage = 'Значение не может быть отрицательным';
          _outputValue = 'Ошибка';
          return;
        }

        result = _fromUnit.convertTo(inputDouble, _toUnit);
      }

      if (result == result.toInt()) {
        _outputValue = result.toInt().toString();
      } else if (result.abs() < 0.0001 && result != 0) {
        _outputValue = result.toStringAsExponential(4);
      } else if (result.abs() > 1e10) {
        _outputValue = result.toStringAsExponential(4);
      } else {
        _outputValue = result.toStringAsFixed(6);

        while (_outputValue.contains('.') && _outputValue.endsWith('0')) {
          _outputValue = _outputValue.substring(0, _outputValue.length - 1);
        }
        if (_outputValue.endsWith('.')) {
          _outputValue = _outputValue.substring(0, _outputValue.length - 1);
        }
      }
    });
  }

  bool _shouldBePositive() {
    final positiveCategoryes = ['Площадь', 'Объём', 'Данные', 'Время'];
    return positiveCategoryes.contains(widget.category.name);
  }

  void _onKeyPressed(String key) {
    setState(() {
      if (_inputValue == '0' && key != '.') {
        _inputValue = key;
      } else if (key == '.') {
        if (!_inputValue.contains('.')) {
          _inputValue += key;
        }
      } else if (key == '00') {
        if (_inputValue != '0') {
          _inputValue += '00';
        }
      } else {

        if (_inputValue.replaceAll('.', '').length < 15) {
          _inputValue += key;
        }
      }
      _convert();
    });
  }

  void _onBackspace() {
    setState(() {
      if (_inputValue.length > 1) {
        _inputValue = _inputValue.substring(0, _inputValue.length - 1);
        if (_inputValue == '-') {
          _inputValue = '0';
        }
      } else {
        _inputValue = '0';
      }
      _convert();
    });
  }

  void _onClear() {
    setState(() {
      _inputValue = '0';
      _errorMessage = null;
      _convert();
    });
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _convert();
    });
  }

  void _showUnitPicker(bool isFromUnit) {
    final themeProvider = ThemeProviderInherited.of(context);
    final isDark = themeProvider.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isFromUnit ? 'Из:' : 'В:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.category.color,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: widget.category.units.length,
                    itemBuilder: (context, index) {
                      final unit = widget.category.units[index];
                      final isSelected =
                          isFromUnit ? unit == _fromUnit : unit == _toUnit;
                      return ListTile(
                        leading: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected ? widget.category.color : Colors.grey,
                        ),
                        title: Text(
                          unit.name,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          unit.symbol,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (isFromUnit) {
                              _fromUnit = unit;
                            } else {
                              _toUnit = unit;
                            }
                            _convert();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProviderInherited.of(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDark ? widget.category.color.withOpacity(0.8) : widget.category.color,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [

          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            final keypadHeight = constraints.maxHeight * 0.45;
            final contentHeight = constraints.maxHeight - keypadHeight;

            return Column(
              children: [

                SizedBox(
                  height: contentHeight,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        _buildConversionCard(
                          label: 'Из:',
                          unit: _fromUnit,
                          value: _inputValue,
                          isInput: true,
                          onTap: () => _showUnitPicker(true),
                          isDark: isDark,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: IconButton(
                            onPressed: _swapUnits,
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.category.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.category.color.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.swap_vert,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),

                        _buildConversionCard(
                          label: 'В:',
                          unit: _toUnit,
                          value: _outputValue,
                          isInput: false,
                          onTap: () => _showUnitPicker(false),
                          isDark: isDark,
                        ),

                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.red[900]!.withOpacity(0.3) : Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isDark ? Colors.red[700]! : Colors.red[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: isDark ? Colors.red[300] : Colors.red[700], size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: isDark ? Colors.red[300] : Colors.red[700],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: keypadHeight,
                  child: NumericKeypad(
                    onKeyPressed: _onKeyPressed,
                    onBackspace: _onBackspace,
                    onClear: _onClear,
                    isDark: isDark,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildConversionCard({
    required String label,
    required Unit unit,
    required String value,
    required bool isInput,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark
              ? (isInput ? const Color(0xFF1E1E1E) : const Color(0xFF2A2A2A))
              : (isInput ? Colors.white : Colors.grey[100]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.category.color.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          unit.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: widget.category.color,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.category.color,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isInput
                          ? (isDark ? Colors.white : Colors.black)
                          : widget.category.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  unit.symbol,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
