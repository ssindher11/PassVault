import 'package:pass_vault/data/models/local/vault_entity.dart';
import 'package:pass_vault/domain/entities/vault_model.dart';

extension VaultMapper on Vault {
  VaultModel toVaultModel() {
    return VaultModel(
        id: id,
        category: category,
        username: username,
        siteAddress: siteAddress,
        passwordHash: passwordHash,
        isFavourite: isFavourite,
        updatedAt: updatedAt);
  }
}

extension VaultModelMapper on VaultModel {
  Vault toVault() {
    return Vault.optional(
      id: id,
      category: category,
      username: username,
      siteAddress: siteAddress,
      passwordHash: passwordHash,
      isFavourite: isFavourite,
      updatedAt: updatedAt
    );
  }

  toNewVault() {
    return Vault.optional(
        category: category,
        username: username,
        siteAddress: siteAddress,
        passwordHash: passwordHash,
    );
  }
}
