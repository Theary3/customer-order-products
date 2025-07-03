
import 'package:mobileassignment/screens/homepage/home.dart';
import '../homepage/home.dart';
import 'package:mobileassignment/screens/login/login_screen.dart';
import '../login/login_screen.dart';
import '../profile/order_history.dart';
import 'package:mobileassignment/screens/profile/order_history.dart';
import 'package:mobileassignment/screens/profile/paymentmethod_screen.dart';
import 'package:mobileassignment/screens/profile/order_history.dart';
import 'package:mobileassignment/screens/profile/yourprofile_screen.dart';
import 'package:mobileassignment/screens/profile/about_us.dart';
import 'package:flutter/material.dart';
import '../homepage/home.dart';
import 'order_history.dart';
class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
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
      body: Column(
        children: [
          SizedBox(height: 15),
          Text(
            "Profile",
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 12,
                  child: Icon(Icons.edit, size: 14, color: Color(0xff997054)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Sun Li",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ProfileOption(
                  icon: Icons.person_outline,
                  title: 'Your profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  YourprofileScreen(),
                      ),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.payment,
                  title: 'Payment Methods',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodsScreen(),
                      ),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrdersHistory(),
                      ),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                ),
                ProfileOption(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                ),
                ProfileOption(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutUs(),
                      ),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                ),
                ProfileOption(
                  icon: Icons.group_add_outlined,
                  title: 'Invites Friends',
                ),
                ProfileOption(
                  icon: Icons.logout,
                  title: 'Log out',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap, 
    );
  }
}