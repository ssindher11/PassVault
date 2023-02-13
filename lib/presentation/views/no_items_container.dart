import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/res.dart';

class NoItemsContainer extends StatelessWidget {
  const NoItemsContainer({
    required this.message,
    Key? key,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 150, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(addFiles),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
