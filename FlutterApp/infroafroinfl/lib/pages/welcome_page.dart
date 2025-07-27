import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                // App Logo/Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  'African Inflation Predictor',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  'Predict inflation rates across African countries using advanced machine learning models',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Action Buttons
                FilledButton(
                  onPressed: () => Navigator.pushNamed(context, '/predict'),
                  child: const Text(
                    'Start Prediction',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/about'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(color: theme.colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Learn More'),
                ),
                const Spacer(),
                // Footer
                Text(
                  'Powered by Flutter & Machine Learning',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
