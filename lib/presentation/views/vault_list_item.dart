import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pass_vault/domain/entities/vault_model.dart';
import 'package:pass_vault/injection.dart';
import 'package:pass_vault/res/color.dart';

import '../../domain/usecases/get_favicon_use_case.dart';

class VaultListItem extends StatelessWidget {
  VaultListItem({
    required this.vaultModel,
    required this.onFavouriteClick,
    Key? key,
  }) : super(key: key);

  final IGetFaviconUseCase getFaviconUseCase = locator();

  final VaultModel vaultModel;
  final VoidCallback onFavouriteClick;

  // Local prop
  final _isPasswordVisible = false.obs;

  void _togglePasswordVisible() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  final _showClipboard = true.obs;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Row(
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
                child: Image.network(
                    getFaviconUseCase.execute(vaultModel.siteAddress)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vaultModel.username,
                    style: const TextStyle(
                      color: darkBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vaultModel.siteAddress,
                    style: const TextStyle(
                      color: darkBlue,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _isPasswordVisible.value
                              ? vaultModel.passwordHash
                              : '********',
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
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: vaultModel.passwordHash),
                            ).then(
                              (_) {
                                _showClipboard.value = false;
                                Timer(
                                  const Duration(seconds: 1),
                                  () => _showClipboard.value = true,
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Icon(
                            _showClipboard.value ? Icons.copy : Icons.done,
                            color:
                                _showClipboard.value ? darkBlue : Colors.green,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFavouriteClick,
              icon: Icon(
                Icons.favorite,
                color: vaultModel.isFavourite ? redPrimary : greyBorderColor,
                size: 20,
              ),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
