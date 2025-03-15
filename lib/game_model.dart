import 'dart:async';
import 'package:flutter/material.dart';

class CardModel {
  String value;
  bool isFaceUp = false;
  bool isMatched = false;

  CardModel(this.value);
}

class GameModel with ChangeNotifier {
  List<CardModel> cards = [];
  int? firstCardIndex;
  bool isProcessing = false;
  int score = 0;
  int timeElapsed = 0;
  Timer? _timer;

  GameModel() {
    _initializeGame();
    _startTimer();
  }

  void _initializeGame() {
    final values = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
    ]; // 8 pairs for 4x4 grid
    final cardValues = [...values, ...values]..shuffle();
    cards = cardValues.map((value) => CardModel(value)).toList();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeElapsed++;
      notifyListeners();
    });
  }

  void flipCard(int index) async {
    if (isProcessing || cards[index].isFaceUp || cards[index].isMatched) return;

    cards[index].isFaceUp = true;
    notifyListeners();

    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else {
      isProcessing = true;
      final firstCard = cards[firstCardIndex!];
      final secondCard = cards[index];

      if (firstCard.value == secondCard.value) {
        score += 10; // Add points for a match
        firstCard.isMatched = true;
        secondCard.isMatched = true;
        firstCardIndex = null;
      } else {
        score -= 2; // Deduct points for a mismatch
        await Future.delayed(Duration(seconds: 1));
        firstCard.isFaceUp = false;
        secondCard.isFaceUp = false;
        firstCardIndex = null;
      }
      isProcessing = false;
      notifyListeners();

      if (cards.every((card) => card.isMatched)) {
        _timer?.cancel();
        _showVictoryMessage();
      }
    }
  }

  void _showVictoryMessage() {
    print('You Win! Score: $score, Time: $timeElapsed seconds');
  }

  void resetGame() {
    _timer?.cancel();
    timeElapsed = 0;
    score = 0;
    firstCardIndex = null;
    isProcessing = false;
    _initializeGame();
    _startTimer();
    notifyListeners();
  }
}
