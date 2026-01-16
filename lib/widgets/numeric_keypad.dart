import 'package:flutter/material.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final bool isDark;

  const NumericKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
    required this.onClear,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [

          Expanded(child: _buildRow(['1', '2', '3'])),
          const SizedBox(height: 6),
 
          Expanded(child: _buildRow(['4', '5', '6'])),
          const SizedBox(height: 6),
 
          Expanded(child: _buildRow(['7', '8', '9'])),
          const SizedBox(height: 6),

          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildKeyButton('.')),
                const SizedBox(width: 6),
                Expanded(child: _buildKeyButton('0')),
                const SizedBox(width: 6),
                Expanded(child: _buildActionButton(Icons.backspace_outlined, onBackspace)),
                const SizedBox(width: 6),
                Expanded(child: _buildClearButton()),
              ],
            ),
          ),
          const SizedBox(height: 6),

          Expanded(
            child: _buildKeyButton('00'),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: keys.asMap().entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: entry.key == 0 ? 0 : 3,
              right: entry.key == keys.length - 1 ? 0 : 3,
            ),
            child: _buildKeyButton(entry.value),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeyButton(String key) {
    return Material(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        onTap: () => onKeyPressed(key),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            key,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 22,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return Material(
      color: Colors.red[400],
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        onTap: onClear,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'C',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
