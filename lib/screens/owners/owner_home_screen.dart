import 'package:flutter/material.dart';
import 'owner_profile_screen.dart';
import '../../services/auth_service.dart'; // make sure path is correct

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    Future<void> logout() async {
      await authService.logout();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/role_selection');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Home'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Welcome, Owner!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Open Shop Locator'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/shop_locator');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('View Profile'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const OwnerProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
