import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/user.dart';
import 'services/auth_service.dart';
import 'theme_provider.dart';
import 'themes.dart';
import 'wrapper.dart';

void main() async {
  // initialize WidgetsFlutterBinding
  WidgetsFlutterBinding.ensureInitialized();


  // initialize firebase app for database manipulations
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService()
          .user, // provides a user stream which tracks updates in our user credentials
      initialData: null,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyThemeProvider(),
          ),
        ],
        child: MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          home:
              const Wrapper(), // it decides whether to show the authentication screen or user dashboard
        ),
      ),
    );
  }
}


