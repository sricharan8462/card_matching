import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => GameModel(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Card Matching Game', home: GameScreen());
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Card Matching Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: game.cards.length,
          itemBuilder: (context, index) {
            final card = game.cards[index];
            return GestureDetector(
              onTap: () => game.flipCard(index),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      card.isFaceUp || card.isMatched
                          ? Colors.white
                          : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child:
                      card.isFaceUp || card.isMatched
                          ? Text(card.value, style: TextStyle(fontSize: 24))
                          : Icon(
                            Icons.question_mark,
                            size: 40,
                            color: Colors.white,
                          ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
