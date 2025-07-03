import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const double _defaultPadding = 30.0;
  static const double _imageSpacing = 15.0;
  static const double _sectionSpacing = 40.0;
  static const double _smallSpacing = 20.0;
  static const double _textSpacing = 10.0;
  static const Color _primaryColor = Color(0xFF997054);
  static const Color _accentColor = Colors.brown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(_defaultPadding),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: _buildImageSection(),
              ),
              Expanded(
                flex: 2,
                child: _buildTextSection(),
              ),
              Expanded(
                flex: 2,
                child: _buildActionButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        Expanded(
          flex: 3,
          child: _buildRoundedImage(
            'assets/images/fashion1.jpg',
          ),
        ),
        const SizedBox(width: _imageSpacing),

        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: _buildRoundedImage(
                  'assets/images/fashion2.jpg',
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _buildRoundedImage(
                  'assets/images/fashion3.jpg',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoundedImage(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60),
      child: Image.asset(
        assetPath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 50,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: 'The ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Fashion App ',
                style: TextStyle(color: _accentColor),
              ),
              TextSpan(text: 'That Makes You Look Your Best'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Style starts here. Discover the latest trends and timeless essentials — all in one place.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onGetStartedPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: const Text(
              "Let's Get Started",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
    
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account? ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: _onSignInPressed,
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: _accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  void _onGetStartedPressed() {

    Navigator.pushNamed(context, '/login').catchError((error) {
  
      debugPrint('Navigation error: $error');
    });
  }

  void _onSignInPressed() {

    Navigator.pushNamed(context, '/signin').catchError((error) {
      debugPrint('Navigation error: $error');
    });
  }
}