import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_with_provider/providers/user_provider.dart';
import 'package:instagram_with_provider/responsive/mobilescreen_layout.dart';
import 'package:instagram_with_provider/responsive/responsive_layout_screen.dart';
import 'package:instagram_with_provider/responsive/webscreen_layout.dart';
import 'package:instagram_with_provider/screens/login_screen.dart';
import 'package:instagram_with_provider/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCwelURXfk3NbJfRvhJQ0rPqm3sQ_Um4zY",
        appId: "1:1065747582432:web:a9399cb3998b63c6da6f85",
        authDomain: "instagram-clone-9adcc.firebaseapp.com",
        messagingSenderId: "1065747582432",
        projectId: "instagram-clone-9adcc",
        storageBucket: "instagram-clone-9adcc.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackground,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.active) {
              if (snap.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snap.hasError) {
                return Center(
                  child: Text(snap.error.toString()),
                );
              }
            } else if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
