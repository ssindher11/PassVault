import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_vault/res/color.dart';

import '../../domain/usecases/get_favicon_use_case.dart';

class VaultListItem extends StatelessWidget {
  VaultListItem({Key? key}) : super(key: key);

  final IGetFaviconUseCase getFaviconUseCase = GetFaviconUseCase();

  // TODO: Get from parent
  final username = "Netflix";
  final siteAddress = "netflix.com";
  final password = "super@secret";

  // final Function onFavourite;

  final isFavourite = false.obs;

  void _toggleFavourite(bool isFavourite) {
    this.isFavourite.value = isFavourite;
  }

  // Local prop
  final _isPasswordVisible = false.obs;

  void _togglePasswordVisible() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Obx(
          () => Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(14),
                child: Center(
                  child: Image.network(getFaviconUseCase.execute(siteAddress)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: darkBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      siteAddress,
                      style: const TextStyle(
                        color: darkBlue,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      // alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,

                      children: [
                        Text(
                          _isPasswordVisible.value ? password : '********',
                          style: const TextStyle(
                            color: darkBlue,
                            fontSize: 12,
                          ),
                        ),
                        InkWell(
                          onTap: () => _togglePasswordVisible(),
                          borderRadius: BorderRadius.circular(8),
                          child: Icon(
                            _isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: darkBlue,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _toggleFavourite(!isFavourite.value),
                icon: Icon(
                  Icons.favorite,
                  color: isFavourite.value ? redPrimary : greyBorderColor,
                  size: 20,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
