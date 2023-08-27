import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'views/photo_register_view.dart';
import 'views/history_view.dart';
import 'views/alarm_creation_view.dart';
import 'views/profile_view.dart';
import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseOptions options = FirebaseOptions(
      apiKey: "AIzaSyDZUZmbinbDrR5Jw1_0mo7nWj2WA1eHdYI",
      authDomain: "dientes-sanos.firebaseapp.com",
      projectId: "dientes-sanos",
      storageBucket: "dientes-sanos.appspot.com",
      messagingSenderId: "873353839538",
      appId: "1:873353839538:web:72c71914e556076e0adaab"
  );

  await Firebase.initializeApp(options: options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica Dental',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: AuthHandler(),
    );
  }
}

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginView();
          } else {
            return MainNavigation();  // Cambiado a tu navegación principal.
          }
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final _pages = [
    PhotoRegisterView(),
    HistoryView(),
    AlarmCreationView(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Clínica Dental'),
      ),
      body: Center(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.lightBlue,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blue[100],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Fotos'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarmas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Acción',
        child: const Icon(Icons.add),
      ),
    );
  }
}
