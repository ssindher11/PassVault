import 'package:pass_vault/data/models/local/vault_entity.dart';

import '../../../domain/entities/vault_model.dart';
import '../../../domain/entities/category.dart';

extension VaultMapper on Vault {
  VaultModel toVaultModel() {
    return VaultModel(
        id: id,
        category: _getCategoryFromString(category),
        username: username,
        siteAddress: siteAddress,
        passwordHash: passwordHash,
        isFavourite: isFavourite,
        updatedAt: updatedAt);
  }

  Category _getCategoryFromString(String value) {
    switch (value) {
      case 'Browser':
        return Category.browser;

      case 'Mobile app':
        return Category.mobile;

      case 'Payment':
        return Category.payment;

      default:
        return Category.browser;
    }
  }
}

extension VaultModelMapper on VaultModel {
  Vault toVault() {
    return Vault.optional(
      id: id,
      category: category.value,
      username: username,
      siteAddress: siteAddress,
      passwordHash: passwordHash,
      isFavourite: isFavourite,
      updatedAt: updatedAt
    );
  }

  toNewVault() {
    return Vault.optional(
        category: category.value,
        username: username,
        siteAddress: siteAddress,
        passwordHash: passwordHash,
    );
  }
}
