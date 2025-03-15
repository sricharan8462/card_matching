import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameModel(), // Placeholder for GameModel
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      home: Scaffold(
        appBar: AppBar(title: Text('Card Matching Game')),
        body: Center(child: Text('Hello, Flutter!')),
      ),
    );
  }
}

// Placeholder GameModel class
class GameModel with ChangeNotifier {}