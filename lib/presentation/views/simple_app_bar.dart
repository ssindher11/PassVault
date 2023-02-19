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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FloatingActionButton.small(
              onPressed: () => onBackPress ?? Navigator.pop(context),
              backgroundColor: Colors.white,
              foregroundColor: darkBlue,
              heroTag: null,
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
