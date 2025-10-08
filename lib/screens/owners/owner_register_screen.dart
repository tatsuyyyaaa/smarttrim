import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import 'owner_home_screen.dart';

class OwnerRegisterScreen extends StatefulWidget {
  const OwnerRegisterScreen({super.key});

  @override
  State<OwnerRegisterScreen> createState() => _OwnerRegisterScreenState();
}

class _OwnerRegisterScreenState extends State<OwnerRegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController shopController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  File? businessPermit;
  File? ownerId;
  bool _isLoading = false;

  Future<void> pickFile(bool isBusinessPermit) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        if (isBusinessPermit) {
          businessPermit = File(result.files.single.path!);
        } else {
          ownerId = File(result.files.single.path!);
        }
      });
    }
  }

  Future<String?> uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> registerOwner() async {
    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")));
      return;
    }
    if (businessPermit == null || ownerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please upload Business Permit and Owner ID")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final businessUrl =
          await uploadFile(businessPermit!, "owners/${cred.user!.uid}/business_permit");
      final idUrl =
          await uploadFile(ownerId!, "owners/${cred.user!.uid}/owner_id");

      await FirebaseFirestore.instance
          .collection("owners")
          .doc(cred.user!.uid)
          .set({
        "fullName": fullNameController.text.trim(),
        "contact": contactController.text.trim(),
        "shopName": shopController.text.trim(),
        "address": addressController.text.trim(),
        "email": emailController.text.trim(),
        "businessPermitUrl": businessUrl,
        "ownerIdUrl": idUrl,
        "verificationStatus": "pending",
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerHomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Registration failed")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Owner Registration")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                        controller: fullNameController, hintText: "Full Name"),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: contactController, hintText: "Contact Number"),
                    const SizedBox(height: 10),
                    CustomTextField(controller: shopController, hintText: "Shop Name"),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: addressController, hintText: "Shop Address"),
                    const SizedBox(height: 10),
                    CustomTextField(controller: emailController, hintText: "Email"),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: confirmController,
                        hintText: "Confirm Password",
                        obscureText: true),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => pickFile(true),
                      child: const Text("Upload Business Permit"),
                    ),
                    ElevatedButton(
                      onPressed: () => pickFile(false),
                      child: const Text("Upload Owner ID"),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        text: "Register Owner", onPressed: registerOwner),
                  ],
                ),
              ),
      ),
    );
  }
}
