import 'package:flutter/material.dart';

class Greeting extends StatelessWidget {
  const Greeting({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hello $name 👋',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome back again!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
