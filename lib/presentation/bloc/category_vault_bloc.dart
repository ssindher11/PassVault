import 'package:pass_vault/domain/entities/vault_model.dart';
import 'package:pass_vault/domain/repositories/vault_repository.dart';

import '../../domain/entities/category.dart';

class CategoryVaultBloc {
  final VaultRepository _vaultRepository;

  CategoryVaultBloc(this._vaultRepository);

  Stream<List<VaultModel>> getCategoryVaults({
    required Category category,
    String query = '',
  }) =>
      _vaultRepository.fetchAllVaultsFromCategory(category.value, query);

  void toggleVaultIsFavourite(VaultModel vaultModel) {
    final updatedVault = VaultModel(
      id: vaultModel.id,
      category: vaultModel.category,
      username: vaultModel.username,
      siteAddress: vaultModel.siteAddress,
      passwordHash: vaultModel.passwordHash,
      isFavourite: !vaultModel.isFavourite,
      updatedAt: vaultModel.updatedAt,
    );
    _vaultRepository.updateVault(updatedVault);
  }

  void deleteVault(VaultModel vaultModel) =>
      _vaultRepository.deleteVault(vaultModel);
}
