import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/welcome_page.dart';
import 'pages/prediction_form.dart';
import 'pages/result_page.dart';
import 'pages/about_page.dart';

void main() => runApp(const InflationPredictorApp());

class InflationPredictorApp extends StatelessWidget {
  const InflationPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'African Inflation Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple[300]!,
          secondary: Colors.deepPurple[200]!,
          surface: const Color(0xFF1E1E1E),
          background: const Color(0xFF121212),
          onBackground: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.copyWith(
                headlineLarge: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                titleLarge: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                bodyLarge: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                labelLarge: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[300],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E1E),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: const WelcomePage(),
      routes: {
        '/predict': (context) => const PredictionFormPage(),
        '/result': (context) {
          final result = ModalRoute.of(context)!.settings.arguments as String? ?? '';
          return ResultPage(result: result);
        },
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
