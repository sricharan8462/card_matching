import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_model.dart';
import 'card_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => GameModel(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameScreen(),
    );
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: ${game.score}', style: TextStyle(fontSize: 20)),
                Text(
                  'Time: ${game.timeElapsed}s',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4x4 grid
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: game.cards.length,
                itemBuilder: (context, index) {
                  return CardWidget(index: index);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => game.resetGame(),
              child: Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}
