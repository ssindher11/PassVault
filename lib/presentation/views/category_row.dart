import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_vault/res/color.dart';
import 'package:pass_vault/res/images.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    required this.categoryCount,
    required this.onCategoryClick,
    Key? key,
  }) : super(key: key);

  final Map<String, int> categoryCount;
  final Function(String category) onCategoryClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: CategoryCard(
            categoryName: 'Browser',
            iconPath: categoryBrowser,
            numPasswords: categoryCount['Browser'] ?? 0,
            onTap: () => onCategoryClick('Browser'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: CategoryCard(
            categoryName: 'Mobile app',
            iconPath: categoryMobile,
            numPasswords: categoryCount['Mobile app'] ?? 0,
            onTap: () => onCategoryClick('Mobile app'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: CategoryCard(
            categoryName: 'Payment',
            iconPath: categoryPayment,
            numPasswords: categoryCount['Payment'] ?? 0,
            onTap: () => onCategoryClick('BrowserPayment'),
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.categoryName,
    required this.iconPath,
    required this.numPasswords,
    required this.onTap,
  }) : super(key: key);

  final String categoryName;
  final String iconPath;
  final int numPasswords;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: lightBg, shape: BoxShape.circle),
                  height: 44,
                  width: 44,
                  child: Center(
                    child: SvgPicture.asset(iconPath),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  categoryName,
                  style: const TextStyle(
                    color: darkTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$numPasswords Password',
                  style: const TextStyle(
                    color: greyTextColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
