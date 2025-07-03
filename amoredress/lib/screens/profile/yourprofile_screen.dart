import 'package:flutter/material.dart';

class YourprofileScreen extends StatefulWidget {
  const YourprofileScreen({super.key});

  @override
  State<YourprofileScreen> createState() => _YourprofileScreenState();
}

class _YourprofileScreenState extends State<YourprofileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController( );
  final TextEditingController _addressController = TextEditingController(
    
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text("Back", style: TextStyle(color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Your Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 14,
                    child: Icon(Icons.edit, size: 14, color: Color(0xff997054)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Don't worry. Only you can see your personal data.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            _buildName(_nameController),
            SizedBox(height: 20),
            _buildEmail(_emailController),
            SizedBox(height: 20),
            _buildPhoneNumber(_phoneController),
            SizedBox(height: 20),
            _buildAddress(_addressController),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff997054),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _saveChanges();
              },

              child: Text("Save Change", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 23),
          ],
        ),
      ),
    );
  }

  Widget _buildName(TextEditingController nameController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name", style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Sun Li",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xff997054), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmail(TextEditingController emailController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "sunli@email.com",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xff997054), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumber(TextEditingController phoneController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Phone Number", style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: "+855 123 456 789",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xff997054), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddress(TextEditingController addressController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address", style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: "Phnom Penh, Cambodia",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xff997054), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Information Saved:\nName: $name\nEmail: $email\nPhone: $phone\nAddress: $address",
        ),
      ),
    );
  }
}
