import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String result;
  final bool isPositive;
  
  const ResultPage({
    Key? key, 
    required this.result,
    this.isPositive = false,
  }) : super(key: key);

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
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Prediction Result',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Result Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Animated Icon
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isPositive 
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPositive ? Icons.trending_up : Icons.trending_down,
                                size: 48,
                                color: isPositive ? Colors.red : Colors.green,
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Result Title
                            Text(
                              isPositive ? 'Inflation Increase Predicted' : 'Stable Inflation Predicted',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Result Value
                            Text(
                              result,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: isPositive ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Additional Info
                            Text(
                              'Based on the provided economic indicators and historical data, this prediction helps in understanding potential inflation trends for the selected country.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[400],
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      Row(
                        children: [
                          // New Prediction Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                side: BorderSide(color: theme.colorScheme.primary),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('New Prediction'),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Home Button
                          Expanded(
                            child: FilledButton(
                              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Back to Home'),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Additional Actions
                      TextButton(
                        onPressed: () {
                          // TODO: Implement share functionality
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.share_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Share Results',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
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
    );
  }
}
