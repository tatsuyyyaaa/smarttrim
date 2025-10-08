import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class ShopLocatorScreen extends StatelessWidget {
  const ShopLocatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final ownerId = authService.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Shop Locator")),
      body: ownerId == null
          ? const Center(child: Text("No owner logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("owners").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No shops available"));
                }

                final shops = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    return Card(
                      child: ListTile(
                        title: Text(shop['shopName'] ?? "Unknown Shop"),
                        subtitle: Text(shop['address'] ?? "No Address"),
                        trailing: Text(shop['verificationStatus'] ?? "pending"),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
