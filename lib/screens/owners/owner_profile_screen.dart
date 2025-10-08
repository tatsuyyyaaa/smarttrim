import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  Map<String, dynamic>? ownerData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOwnerData();
  }

  Future<void> _loadOwnerData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('owners')
        .doc(user.uid)
        .get();

    if (mounted) {
      setState(() {
        ownerData = doc.data();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ownerData == null
              ? const Center(child: Text('No data found'))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      Text('Full Name: ${ownerData!['fullName']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Email: ${ownerData!['email']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Contact Number: ${ownerData!['contact']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Shop Name: ${ownerData!['shopName']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Address: ${ownerData!['address']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      ownerData!['businessPermitUrl'] != null
                          ? Image.network(ownerData!['businessPermitUrl'])
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      ownerData!['ownerIdUrl'] != null
                          ? Image.network(ownerData!['ownerIdUrl'])
                          : const SizedBox(),
                    ],
                  ),
                ),
    );
  }
}
