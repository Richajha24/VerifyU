import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/user_provider.dart';
import 'providers/credential_provider.dart';
import 'providers/opportunity_provider.dart';
import 'providers/navigator_provider.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/main_navigation_holder.dart';
import 'screens/add_credential.dart';
import 'screens/achievement_detail.dart';
import 'screens/share_card.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization failed: $e. Using local database mock options.");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CredentialProvider()),
        ChangeNotifierProvider(create: (_) => OpportunityProvider()),
        ChangeNotifierProvider(create: (_) => NavigatorProvider()),
      ],
      child: MaterialApp(
        title: 'VerifyU',
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/main': (context) => const MainNavigationHolder(),
          '/add_credential': (context) => const AddCredentialScreen(),
          '/credential_detail': (context) => const AchievementDetailScreen(),
          '/share_card': (context) => const ShareCardScreen(),
        },
      ),
    );
  }
}