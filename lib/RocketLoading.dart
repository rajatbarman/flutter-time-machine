import 'package:flutter/material.dart';

class RocketLoading extends StatefulWidget {
  final ValueNotifier<bool> loadingFinishedNotifier;
  // final VoidCallback onAnimationEnd;
  const RocketLoading({super.key, required this.loadingFinishedNotifier});

  @override
  State<RocketLoading> createState() => _RocketLoadingState();
}

class _RocketLoadingState extends State<RocketLoading>
    with TickerProviderStateMixin {
  late AnimationController _movementAnimController;
  late Animation<Offset> _movementAnimation;
  bool _isControllerDisposed = false;

  @override
  void initState() {
    super.initState();

    _movementAnimController =
        AnimationController(vsync: this, duration: const Duration(seconds: 45))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _isControllerDisposed = true;
              _movementAnimController.dispose();
            }
          });

    _movementAnimation = Tween<Offset>(
      begin: Offset(0, 0), // Start position (left side of the screen)
      end: Offset(0, -2), // End position (right side of the screen)
    ).animate(CurvedAnimation(
        parent: _movementAnimController, curve: Curves.easeInOut));

    _movementAnimController.forward(from: 0);

    widget.loadingFinishedNotifier.addListener(() {
      if (widget.loadingFinishedNotifier.value) {
        if (_isControllerDisposed) {
          return;
        }
        final double progress = _movementAnimController.value;
        const newDuration = const Duration(seconds: 2);
        _movementAnimController.duration = newDuration;
        _movementAnimController.forward(from: progress);
        widget.loadingFinishedNotifier.value = false; // Reset the notifier
      }
    });
  }

  @override
  void dispose() {
    if (_isControllerDisposed) {
      super.dispose();
      return;
    }
    _movementAnimController.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _movementAnimController,
        ]),
        builder: (context, child) {
          return Transform.translate(
              offset: _movementAnimation.value *
                  MediaQuery.of(context).size.height /
                  2,
              child: Image.asset('assets/images/machine-on.png',
                  width: 120, height: 120));
        });
  }
}
