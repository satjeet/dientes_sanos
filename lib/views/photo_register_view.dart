import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
import 'dart:typed_data';

class PhotoRegisterView extends StatefulWidget {
  @override
  _PhotoRegisterViewState createState() => _PhotoRegisterViewState();
}

class _PhotoRegisterViewState extends State<PhotoRegisterView> {
  final ImagePicker picker = ImagePicker();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Fotografias', style: TextStyle(fontFamily: 'NotoSans')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Aqui ira el registro de fotografias', style: TextStyle(fontFamily: 'NotoSans')),
            if (imageUrl != null)
              Image.network(imageUrl!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleccionar Imagen', style: TextStyle(fontFamily: 'NotoSans')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No hay un usuario autenticado');
      return;
    }
    print('UID del usuario autenticado: ${user.uid}');

    final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    input.onChange.listen((event) async {
      final file = input.files!.first;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) async {
        // Convierte el ArrayBuffer a Uint8List
        final buffer = reader.result as List<int>;
        final data = Uint8List.fromList(buffer);
        final String uid = user.uid;

        // Comprobando y creando documento de usuario si no existe
        final userRef = FirebaseFirestore.instance.collection('usuarios').doc(uid);
        final userDoc = await userRef.get();
        if (!userDoc.exists) {
          await userRef.set({
            'nombre': user.displayName,
            'correo': user.email,
            'uid': user.uid,
            // Agrega otros campos aquí si es necesario
          });
        }

        // Guardando en Firebase Storage
        final Reference ref = FirebaseStorage.instance.ref().child('usuarios/$uid/cepillados/${DateTime.now().toIso8601String()}.png');
        await ref.putData(Uint8List.fromList(data));

        final String imageUrl = await ref.getDownloadURL();

        // Guardando en Firestore
        await userRef.collection('cepillados').add({
          'imageUrl': imageUrl,
          'timestamp': DateTime.now()
        });
      });

      reader.readAsArrayBuffer(file);
    });
  }
}
