import 'package:flutter/material.dart';

class InputButton extends StatefulWidget {
  final String value;
  final void Function()? onTap;
  final bool small;

  const InputButton(
      {Key? key, required this.value, this.onTap, this.small: false})
      : super(key: key);

  @override
  State<InputButton> createState() => _InputButtonState();
}

class _InputButtonState extends State<InputButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  _InputButtonState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween<double>(begin: 1, end: .97).animate(_animationController);

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: Transform.scale(
        scale: animation.value,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(widget.small ? 10 : 15),
          child: Center(
              child: Text(widget.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.small ? 13 : 20,
                  ))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
