import 'package:flutter/material.dart';

class CustomChoiceChip extends StatefulWidget {
  const CustomChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.backgroundColor,
    this.selectedColor,
    this.borderRadius,
    this.labelPadding,
    this.chipMargin,
    Key? key,
  }) : super(key: key);

  final Widget label;
  final Color? backgroundColor;
  final Color? selectedColor;
  final BorderRadius? borderRadius;
  final bool selected;
  final VoidCallback onSelected;
  final EdgeInsets? labelPadding;
  final EdgeInsets? chipMargin;

  @override
  State<CustomChoiceChip> createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends State<CustomChoiceChip>
    with TickerProviderStateMixin {
  late AnimationController selectController;
  late Animation<double> selectionFade;

  @override
  void initState() {
    super.initState();
    selectController = AnimationController(
      duration: const Duration(milliseconds: 195),
      value: widget.selected == true ? 1.0 : 0.0,
      vsync: this,
    );
    selectionFade = CurvedAnimation(
      parent: selectController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    selectController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomChoiceChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected == true) {
        selectController.forward();
      } else {
        selectController.reverse();
      }
    }
  }

  Color? _getBackgroundColor() {
    final ColorTween selectTween = ColorTween(
      begin: widget.backgroundColor,
      end: widget.selectedColor,
    );
    return selectTween.evaluate(selectionFade);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onSelected,
      child: AnimatedBuilder(
        animation: selectController,
        builder: (_, __) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(40),
            ),
            padding: widget.labelPadding,
            margin: widget.chipMargin,
            child: widget.label,
          );
        },
      ),
    );
  }
}
