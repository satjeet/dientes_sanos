import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _registerOrLogin() async {
    try {
      // Primero, intenta iniciar sesión
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      // Si el inicio de sesión falla, intenta registrar al usuario
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        try {
          await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        } catch (e) {
          if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
            // Muestra un mensaje si el correo electrónico ya está en uso
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El correo electrónico ya está en uso.')),
            );
          } else {
            // Muestra cualquier otro error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        }
      } else {
        // Muestra cualquier otro error del inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión/Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _registerOrLogin,
              child: Text('Iniciar Sesión/Registrarse'),
            )
          ],
        ),
      ),
    );
  }
}
