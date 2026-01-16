import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'utils/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ConverterApp());
}

class ConverterApp extends StatefulWidget {
  const ConverterApp({super.key});

  @override
  State<ConverterApp> createState() => _ConverterAppState();
}

class _ConverterAppState extends State<ConverterApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProviderInherited(
      themeProvider: _themeProvider,
      child: MaterialApp(
        title: 'Converter',
        debugShowCheckedModeBanner: false,
        theme: ThemeProvider.lightTheme,
        darkTheme: ThemeProvider.darkTheme,
        themeMode: _themeProvider.themeMode,
        home: const HomeScreen(),
      ),
    );
  }
}

class ThemeProviderInherited extends InheritedWidget {
  final ThemeProvider themeProvider;

  const ThemeProviderInherited({
    super.key,
    required this.themeProvider,
    required super.child,
  });

  static ThemeProvider of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ThemeProviderInherited>();
    return widget!.themeProvider;
  }

  @override
  bool updateShouldNotify(ThemeProviderInherited oldWidget) {
    return themeProvider.themeMode != oldWidget.themeProvider.themeMode;
  }
}
