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

  GameModel() {
    _initializeGame();
  }

  void _initializeGame() {
    final values = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    final cardValues = [...values, ...values]..shuffle();
    cards = cardValues.map((value) => CardModel(value)).toList();
    notifyListeners();
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
        firstCard.isMatched = true;
        secondCard.isMatched = true;
        firstCardIndex = null;
      } else {
        await Future.delayed(Duration(seconds: 1));
        firstCard.isFaceUp = false;
        secondCard.isFaceUp = false;
        firstCardIndex = null;
      }
      isProcessing = false;
      notifyListeners();
    }
  }
}
