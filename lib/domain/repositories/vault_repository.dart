import '../entities/vault_model.dart';

abstract class VaultRepository {
  Future<int> addVault(VaultModel vaultModel);

  Future<int> updateVault(VaultModel vaultModel);

  Future<void> deleteVault(VaultModel vaultModel);

  Future<void> deleteAllVaults();

  Stream<List<VaultModel>> fetchAllVaults(String query);

  Stream<List<VaultModel>> fetchAllVaultsOrderedByRecent(String query);

  Stream<List<VaultModel>> fetchAllVaultsIfFavourites(String query);

  Stream<List<VaultModel>> fetchAllVaultsFromCategory(
    String category,
    String query,
  );
}
