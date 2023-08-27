// lib/views/alarm_creation_view.dart

import 'package:flutter/material.dart';

class AlarmCreationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Alarma'),
      ),
      body: Center(
        child: Text('Aquí se podrá crear alarmas'),
      ),
    );
  }
}
