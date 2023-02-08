import 'package:pass_vault/data/datasources/local/vault_dao.dart';
import 'package:pass_vault/data/models/mappers/vault_mapper.dart';
import 'package:pass_vault/domain/entities/vault_model.dart';
import 'package:pass_vault/domain/repositories/vault_repository.dart';

import '../models/local/vault_entity.dart';

class VaultRepositoryImpl implements VaultRepository {
  final VaultDao vaultDao;

  VaultRepositoryImpl({required this.vaultDao});

  @override
  Future<int> addVault(VaultModel vaultModel) {
    final Vault vault = vaultModel.toNewVault();
    return vaultDao.addVault(vault);
  }

  @override
  Future<void> deleteAllVaults() {
    return vaultDao.deleteAllVaults();
  }

  @override
  Future<void> deleteVault(VaultModel vaultModel) {
    final Vault vault = vaultModel.toVault();
    return vaultDao.deleteVault(vault);
  }

  @override
  Stream<List<VaultModel>> fetchAllVaults(String query) {
    final vaultStream = vaultDao.fetchAllVaults('%$query%');
    return _mapToVaultModelStream(vaultStream);
  }

  @override
  Stream<List<VaultModel>> fetchAllVaultsFromCategory(
    String category,
    String query,
  ) {
    final vaultStream = vaultDao.fetchAllVaultsFromCategory(
      category,
      '%$query%',
    );
    return _mapToVaultModelStream(vaultStream);
  }

  @override
  Stream<List<VaultModel>> fetchAllVaultsIfFavourites(String query) {
    final vaultStream = vaultDao.fetchAllVaultsIfFavourites('%$query%');
    return _mapToVaultModelStream(vaultStream);
  }

  @override
  Stream<List<VaultModel>> fetchAllVaultsOrderedByRecent(String query) {
    final vaultStream = vaultDao.fetchAllVaultsOrderedByRecent('%$query%');
    return _mapToVaultModelStream(vaultStream);
  }

  @override
  Future<int> updateVault(VaultModel vaultModel) {
    final Vault vault = vaultModel.toVault();
    return vaultDao.updateVault(vault);
  }

  Stream<List<VaultModel>> _mapToVaultModelStream(
    Stream<List<Vault>> vaultStream,
  ) {
    final Stream<List<VaultModel>> vaultModelStream = vaultStream.map((list) {
      return list.map((vault) => vault.toVaultModel()).toList();
    });
    return vaultModelStream;
  }
}
