import 'package:pass_vault/domain/entities/vault_model.dart';
import 'package:pass_vault/domain/repositories/vault_repository.dart';
import 'package:rxdart/rxdart.dart';

class VaultBloc {
  final VaultRepository _vaultRepository;

  VaultBloc(this._vaultRepository);

  final BehaviorSubject<List<VaultModel>> _vaultsList =
      BehaviorSubject.seeded([]);

  Stream<List<VaultModel>> get vaultList => _vaultsList.stream;

  final BehaviorSubject<Map<String, int>> _categoryCount =
      BehaviorSubject.seeded({});

  Stream<Map<String, int>> get categoryCount => _categoryCount.stream;

  void fetchAllVaults({String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaults(query);
    _vaultsList.sink.addStream(vaultsStream);
  }

  void fetchAllVaultsOrderedByRecent({String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaultsOrderedByRecent(query);
    _vaultsList.sink.addStream(vaultsStream);
  }

  void fetchAllVaultsIfFavourites({String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaultsIfFavourites(query);
    _vaultsList.sink.addStream(vaultsStream);
  }

  void fetchAllVaultsFromCategory(String category, {String query = ''}) {
    final vaultsStream = _vaultRepository.fetchAllVaultsFromCategory(
      category,
      query,
    );
    _vaultsList.sink.addStream(vaultsStream);
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
    for (var vault in _vaultsList.value) {
      countMap[vault.category] = (countMap[vault.category] ?? 0) + 1;
    }
    _categoryCount.sink.add(countMap);
  }

  void dispose() {
    _vaultsList.close();
  }
}
