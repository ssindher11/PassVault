import 'package:flutter/material.dart';
import 'package:pass_vault/res/color.dart';

class SimpleAppBar extends StatelessWidget {
  const SimpleAppBar({
    Key? key,
    required this.title,
    this.onBackPress,
  }) : super(key: key);

  final String title;
  final VoidCallback? onBackPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          FloatingActionButton.small(
            onPressed: onBackPress,
            backgroundColor: Colors.white,
            foregroundColor: darkBlue,
            child: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}
