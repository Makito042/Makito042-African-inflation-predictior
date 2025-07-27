import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
                      'About',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Info Card
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
                            // App Icon
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.analytics_outlined,
                                size: 40,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // App Name
                            Text(
                              'African Inflation Predictor',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Version
                            Text(
                              'Version 1.0.0',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[400],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Description
                            Text(
                              'This application uses advanced machine learning models to predict inflation trends across African countries. It helps economists, policymakers, and researchers analyze economic indicators and forecast inflation rates with high accuracy.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[300],
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Features
                            _buildFeatureTile(
                              context: context,
                              icon: Icons.analytics,
                              title: 'Advanced Analytics',
                              subtitle: 'Powered by machine learning models',
                            ),
                            _buildFeatureTile(
                              context: context,
                              icon: Icons.trending_up,
                              title: 'Real-time Predictions',
                              subtitle: 'Get instant inflation forecasts',
                            ),
                            _buildFeatureTile(
                              context: context,
                              icon: Icons.public,
                              title: 'Multi-country Support',
                              subtitle: 'Covering major African economies',
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Made with love
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.favorite, color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Made with Flutter',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Developer Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Developer',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person, size: 30),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your Name',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Flutter Developer & Data Scientist',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSocialButton(
                                  context: context,
                                  icon: Icons.code,
                                  label: 'GitHub',
                                  onTap: () => _launchURL('https://github.com/yourusername'),
                                ),
                                _buildSocialButton(
                                  context: context,
                                  icon: Icons.link,
                                  label: 'Portfolio',
                                  onTap: () => _launchURL('https://yourportfolio.com'),
                                ),
                                _buildSocialButton(
                                  context: context,
                                  icon: Icons.email,
                                  label: 'Email',
                                  onTap: () => _launchURL('mailto:your.email@example.com'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Legal Info
                      Text(
                        '© 2025 African Inflation Predictor. All rights reserved.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
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
  
  Widget _buildFeatureTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
  
  Widget _buildSocialButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
