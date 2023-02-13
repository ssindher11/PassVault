import 'package:pass_vault/domain/entities/vault_model.dart';
import 'package:pass_vault/domain/repositories/vault_repository.dart';
import 'package:rxdart/rxdart.dart';

class VaultBloc {
  final VaultRepository _vaultRepository;

  VaultBloc(this._vaultRepository);

  final BehaviorSubject<List<VaultModel>> _allVaultsList =
      BehaviorSubject.seeded([]);

  Stream<List<VaultModel>> get allVaultsList => _allVaultsList.stream;

  final BehaviorSubject<List<VaultModel>> _recentVaultsList =
      BehaviorSubject.seeded([]);

  Stream<List<VaultModel>> get recentVaultsList => _recentVaultsList.stream;

  final BehaviorSubject<List<VaultModel>> _favouriteVaultsList =
      BehaviorSubject.seeded([]);

  Stream<List<VaultModel>> get favouriteVaultsList => _favouriteVaultsList.stream;

  final BehaviorSubject<Map<String, int>> _categoryCount =
      BehaviorSubject.seeded({});

  Stream<Map<String, int>> get categoryCount => _categoryCount.stream;

  void fetchAllVaults({String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaults(query);
    _allVaultsList.sink.addStream(vaultsStream);
  }

  void fetchAllVaultsOrderedByRecent({String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaultsOrderedByRecent(query);
    _recentVaultsList.sink.addStream(vaultsStream);
  }

  void fetchAllVaultsIfFavourites({String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaultsIfFavourites(query);
    _favouriteVaultsList.sink.addStream(vaultsStream);
  }

  void fetchAllVaultsFromCategory(String category, {String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaultsFromCategory(
      category,
      query,
    );
    _allVaultsList.sink.addStream(vaultsStream);
  }

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

  void deleteVault(VaultModel vaultModel) {
    _vaultRepository.deleteVault(vaultModel);
  }

  void updateCategoryCount() {
    Map<String, int> countMap = {};
    for (var vault in _allVaultsList.value) {
      countMap[vault.category] = (countMap[vault.category] ?? 0) + 1;
    }
    _categoryCount.sink.add(countMap);
  }

  void dispose() {
    _allVaultsList.close();
    _recentVaultsList.close();
    _favouriteVaultsList.close();
  }
}
