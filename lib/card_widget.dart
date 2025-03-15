import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_model.dart';

class CardWidget extends StatefulWidget {
  final int index;

  CardWidget({required this.index});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFaceUp = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameModel>(context);
    final card = game.cards[widget.index];

    // Update animation based on card state
    if (card.isFaceUp != _isFaceUp) {
      if (card.isFaceUp) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _isFaceUp = card.isFaceUp; // Sync local state
    }

    return GestureDetector(
      onTap: () => game.flipCard(widget.index),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFaceUp = card.isFaceUp || card.isMatched;
          // Flip only to 90 degrees max (π/2)
          final angle = _animation.value * 1.5708; // π/2 radians = 90 degrees

          // Show front only when animation is past halfway
          final showFront = _animation.value > 0.5;

          // Adjust the rotation direction based on the state
          final displayAngle =
              showFront ? (1 - _animation.value) * 1.5708 : angle;

          return Transform(
            transform: Matrix4.rotationY(displayAngle),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isFaceUp && showFront ? Colors.white : Colors.blue,
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child:
                    isFaceUp && showFront
                        ? Text(
                          card.value,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
    );
  }
}
