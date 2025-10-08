import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 👈 Add this
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/users/user_home_screen.dart';
import 'screens/owners/owner_home_screen.dart';
import 'screens/users/user_register_screen.dart';
import 'screens/owners/owner_register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 👈 Important
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartTrim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Initial route can be splash screen
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/role_selection': (context) => const RoleSelectionScreen(),
        '/user_home': (context) => const UserHomeScreen(),
        '/owner_home': (context) => const OwnerHomeScreen(),
        '/user_register': (context) => const UserRegisterScreen(),
        '/owner_register': (context) => const OwnerRegisterScreen(),
      },
    );
  }
}
