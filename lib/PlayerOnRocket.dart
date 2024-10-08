import 'package:flutter/material.dart';
import 'dart:math' as math;

class PlayerOnRocket extends StatefulWidget {
  final ValueNotifier<bool> startAnimationNotifier;
  final VoidCallback onAnimationEnd;
  const PlayerOnRocket(
      {required this.startAnimationNotifier,
      required this.onAnimationEnd,
      super.key});

  @override
  State<PlayerOnRocket> createState() => _PlayerOnRocketState();
}

class _PlayerOnRocketState extends State<PlayerOnRocket>
    with TickerProviderStateMixin {
  late AnimationController _idleAnimController;
  late AnimationController _movementAnimController;
  late AnimationController _scaleAnimController;
  late Animation<double> _zigZagAnimation;
  late Animation<Offset> _movementAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _idleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _movementAnimController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _scaleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _movementAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scaleAnimController.forward();
      }
    });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _scaleAnimController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // _idleAnimController.reset();
          _movementAnimController.reset();
          _scaleAnimController.reset();
          widget.onAnimationEnd();
        }
      });

    // Animation to run continuously
    _zigZagAnimation = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: _idleAnimController, curve: Curves.easeInOut));

    _movementAnimation = Tween<Offset>(
      begin: Offset(0, 0), // Start position (left side of the screen)
      end: Offset(0, -.8), // End position (right side of the screen)
    ).animate(CurvedAnimation(
        parent: _movementAnimController, curve: Curves.easeInOut));

    widget.startAnimationNotifier.addListener(() {
      if (widget.startAnimationNotifier.value) {
        _movementAnimController.forward(); // Start the animation
        widget.startAnimationNotifier.value = false; // Reset the notifier
      }
    });
  }

  @override
  void dispose() {
    _idleAnimController.dispose();
    _movementAnimController.dispose();
    _scaleAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _idleAnimController,
          _movementAnimController,
          _scaleAnimController
        ]),
        builder: (context, child) {
          return Transform.translate(
              offset: _movementAnimation.value *
                  MediaQuery.of(context).size.height /
                  2,
              child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                      angle: _zigZagAnimation.value *
                          math.pi /
                          180, // Convert to radians
                      child: Image.asset('assets/images/machine.png',
                          width: 80, height: 80))));
        });
  }
}
