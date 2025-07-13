import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DiceButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressedCallback;

  const DiceButton({
    Key? key,
    required this.buttonText,
    required this.onPressedCallback,
  }) : super(key: key);

  @override
  State<DiceButton> createState() => _DiceButtonState();
}

class _DiceButtonState extends State<DiceButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetYAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Ключовий tween для "стрибка" з затуханням (кілька відскоків)
    _offsetYAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -80.0).chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -80.0, end: 20.0).chain(CurveTween(curve: Curves.easeIn)), weight: 15),
      TweenSequenceItem(tween: Tween<double>(begin: 20.0, end: -10.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: -10.0, end: 5.0).chain(CurveTween(curve: Curves.easeIn)), weight: 5),
      TweenSequenceItem(tween: Tween<double>(begin: 5.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 5),
    ]).animate(_controller);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  void _playAnimation() {
    _controller.forward(from: 0);
    widget.onPressedCallback();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDiceFace() {
  return Stack(
    alignment: Alignment.center,
    children: [
      const FaIcon(
        FontAwesomeIcons.diceD20,
        size: 150,
        color: Colors.black, // сам дайс чорного кольору
      ),
      Text(
        widget.buttonText,
        style: const TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.translate(
      offset: Offset(0, _offsetYAnimation.value),
      child: Transform.rotate(
        angle: _rotationAnimation.value,
        child: GestureDetector(
          onTap: _playAnimation,
          child: child,
        ),
      ),
    );
  },
  child: _buildDiceFace(),
)
;
  }
}
