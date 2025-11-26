import 'package:app_comidas/pages/home.dart';
import 'package:flutter/material.dart';

// En su forma actual, solo le indica a Flutter que ejecute la app definida en MyApp.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Construye la app con material design
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'Flutter Demo',
      //Construir con un diseño predefinido
      home: const Home()
    );
  }
}
