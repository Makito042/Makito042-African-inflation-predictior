import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../widgets/binary_dropdown.dart';
import 'result_page.dart';
import 'package:flutter/services.dart';

class PredictionFormPage extends StatefulWidget {
  const PredictionFormPage({Key? key}) : super(key: key);

  @override
  State<PredictionFormPage> createState() => _PredictionFormPageState();
}

class _PredictionFormPageState extends State<PredictionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final List<String> countries = [
    'Algeria', 'Angola', 'Central African Republic', 'Ivory Coast', 'Egypt',
    'Kenya', 'Mauritius', 'Morocco', 'Nigeria', 'South Africa', 'Tunisia', 'Zambia', 'Zimbabwe'
  ];

  // Form field controllers
  String country = 'Algeria';
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _exchUsdController = TextEditingController();
  final TextEditingController _gdpWeightedController = TextEditingController();
  
  // Binary options
  int systemicCrisis = 0;
  int domesticDebt = 0;
  int sovereignDebt = 0;
  int independence = 0;
  int currencyCrises = 0;
  int inflationCrises = 0;
  
  // UI state
  bool _isLoading = false;
  String _result = '';
  
  @override
  void dispose() {
    _yearController.dispose();
    _exchUsdController.dispose();
    _gdpWeightedController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    setState(() {
      _isLoading = true;
      _result = '';
    });
    
    try {
      // Test with a simple GET request first to check connectivity
      try {
        final testResponse = await http.get(
          Uri.parse('https://infoafroapi.onrender.com/')
        ).timeout(const Duration(seconds: 10));
        
        if (kDebugMode) {
          print('Test connection status: ${testResponse.statusCode}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Test connection failed: $e');
        }
        throw Exception('Cannot connect to the server. Please check your internet connection.');
      }
      
      final url = Uri.parse('https://infoafroapi.onrender.com/predict');
      
      // Prepare request body
      final requestBody = {
        "country": country,
        "year": int.parse(_yearController.text),
        "systemic_crisis": systemicCrisis,
        "exch_usd": double.parse(_exchUsdController.text),
        "domestic_debt_in_default": domesticDebt,
        "sovereign_external_debt_default": sovereignDebt,
        "gdp_weighted_default": double.parse(_gdpWeightedController.text),
        "independence": independence,
        "currency_crises": currencyCrises,
        "inflation_crises": inflationCrises
      };
      
      if (kDebugMode) {
        print('Sending prediction request to: $url');
        print('Request headers: ${{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        }}');
        print('Request body: $requestBody');
      }
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          throw TimeoutException('The connection has timed out. The server might be busy. Please try again later.');
        },
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prediction = data['prediction'] ?? data['predicted_inflation'];
        
        if (prediction == null) {
          throw Exception('Invalid response format: No prediction data found');
        }
        
        final predictionValue = double.tryParse(prediction.toString()) ?? 0.0;
        final formattedResult = 'Predicted Inflation: ${predictionValue.toStringAsFixed(2)}%';
        
        if (!mounted) return;
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              result: formattedResult,
              isPositive: predictionValue > 0,
            ),
          ),
        );
      } else {
        String errorMessage = 'Server error (${response.statusCode})';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
        } catch (_) {
          errorMessage = response.body.isNotEmpty 
              ? response.body 
              : 'An unknown error occurred';
        }
        
        if (!mounted) return;
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              result: 'Error: $errorMessage',
              isPositive: false,
            ),
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultPage(
            result: 'Error: Request timed out. Please try again.',
            isPositive: false,
          ),
        ),
      );
    } on FormatException catch (e) {
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            result: 'Error: Invalid response format (${e.message})',
            isPositive: false,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            result: 'Error: ${e.toString().replaceAll('Exception: ', '')}',
            isPositive: false,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inflation Prediction'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator when loading
            if (_isLoading)
              const LinearProgressIndicator(
                minHeight: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              ),
                
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form header
                    _buildSectionHeader(theme, 'Country & Year'),
                    const SizedBox(height: 16),
                    
                    // Country and Year row
                    Row(
                      children: [
                        // Country dropdown
                        Expanded(
                          flex: 2,
                          child: _buildDropdownField(
                            value: country,
                            label: 'Country',
                            items: countries,
                            onChanged: (value) => setState(() => country = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Year input
                        Expanded(
                          child: _buildTextFormField(
                            controller: _yearController,
                            label: 'Year',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final year = int.tryParse(value);
                              if (year == null || year < 1900 || year > 2100) {
                                return 'Invalid year';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader(theme, 'Economic Indicators'),
                    const SizedBox(height: 16),
                    
                    // Economic indicators
                    _buildTextFormField(
                      controller: _exchUsdController,
                      label: 'Exchange Rate (USD)',
                      hint: 'e.g. 1500.75',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _gdpWeightedController,
                      label: 'GDP Weighted Default',
                      hint: 'e.g. 0.05',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader(theme, 'Crisis Indicators'),
                    const SizedBox(height: 8),
                    Text(
                      'Select all that apply',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Crisis indicators grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3,
                      children: [
                        _buildCrisisToggle(
                          title: 'Systemic Crisis',
                          value: systemicCrisis == 1,
                          onChanged: (value) => setState(() => systemicCrisis = value ? 1 : 0),
                        ),
                        _buildCrisisToggle(
                          title: 'Domestic Debt',
                          value: domesticDebt == 1,
                          onChanged: (value) => setState(() => domesticDebt = value ? 1 : 0),
                        ),
                        _buildCrisisToggle(
                          title: 'Sovereign Debt',
                          value: sovereignDebt == 1,
                          onChanged: (value) => setState(() => sovereignDebt = value ? 1 : 0),
                        ),
                        _buildCrisisToggle(
                          title: 'Independence',
                          value: independence == 1,
                          onChanged: (value) => setState(() => independence = value ? 1 : 0),
                        ),
                        _buildCrisisToggle(
                          title: 'Currency Crises',
                          value: currencyCrises == 1,
                          onChanged: (value) => setState(() => currencyCrises = value ? 1 : 0),
                        ),
                        _buildCrisisToggle(
                          title: 'Inflation Crises',
                          value: inflationCrises == 1,
                          onChanged: (value) => setState(() => inflationCrises = value ? 1 : 0),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Prediction result
                    if (_result.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Prediction Result',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Fixed submit button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _predict,
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Icon(Icons.analytics_outlined, size: 20),
                label: Text(_isLoading ? 'Predicting...' : 'Predict Inflation'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  Widget _buildDropdownField<T>({
    required T value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      style: const TextStyle(color: Colors.white),
      dropdownColor: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(12),
    );
  }
  
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
  
  Widget _buildCrisisToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: value 
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: value 
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[800]!,
          width: 1,
        ),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: value 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: value 
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[600]!,
                    width: 2,
                  ),
                ),
                child: value
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: value 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
