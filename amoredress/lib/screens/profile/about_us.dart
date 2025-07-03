import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF6E4222);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/amorebrown1.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Amore Dress',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Style. Comfort. Quality.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Featured Image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/9.jpg',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Story Section
                  _buildSection(
                    title: 'Our Story',
                    content: 'Amore Dress was born from a passion for style and a love for everyday comfort. We started with a simple idea: to make quality fashion accessible to everyone. Our journey began in the heart of Phnom Penh, and we are proud to serve customers across Cambodia.',
                    primaryColor: primaryColor,
                  ),

                  const SizedBox(height: 24),

                  // Mission Section
                  _buildSection(
                    title: 'Our Mission',
                    content: 'To provide a seamless and enjoyable shopping experience with fashionable and affordable clothing for men, women, and children.',
                    primaryColor: primaryColor,
                  ),

                  const SizedBox(height: 32),

                  // Contact Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Get In Touch',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(Icons.location_on, '123str, Phnom Penh, Cambodia'),
                        const SizedBox(height: 12),
                        _buildContactItem(Icons.phone, '+855 12 345 678'),
                        const SizedBox(height: 12),
                        _buildContactItem(Icons.email, 'support@amoredress.com'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Footer
                  Text(
                    'Developed with ❤️ by AMORE Team',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required Color primaryColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}