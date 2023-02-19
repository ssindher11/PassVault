import 'package:floor/floor.dart';
import 'package:pass_vault/data/models/local/vault_entity.dart';

@dao
abstract class VaultDao {
  @insert
  Future<int> addVault(Vault vault);

  @update
  Future<int> updateVault(Vault vault);

  @delete
  Future<void> deleteVault(Vault vault);

  @delete
  Future<void> _deleteVaults(List<Vault> vaults);

  @Query('SELECT * FROM vault')
  Future<List<Vault>> _fetchAllVaults();

  @transaction
  Future<void> deleteAllVaults() async {
    final vaultsList = await _fetchAllVaults();
    await _deleteVaults(vaultsList);
  }

  @Query('SELECT * FROM vault '
      'WHERE UPPER(username) LIKE UPPER(:query) '
      'OR UPPER(site_address) LIKE UPPER(:query) '
      'ORDER BY username ASC')
  Stream<List<Vault>> fetchAllVaults(String query);

  @Query('SELECT * FROM vault '
      'WHERE UPPER(username) LIKE UPPER(:query) '
      'OR UPPER(site_address) LIKE UPPER(:query) '
      'ORDER BY updated_at DESC, username ASC')
  Stream<List<Vault>> fetchAllVaultsOrderedByRecent(String query);

  @Query('SELECT * FROM vault '
      'WHERE is_favourite = true AND UPPER(username) LIKE UPPER(:query) '
      'OR UPPER(site_address) LIKE UPPER(:query) '
      'ORDER BY username ASC')
  Stream<List<Vault>> fetchAllVaultsIfFavourites(String query);

  @Query('SELECT * FROM vault '
      'WHERE category = :category '
      'AND UPPER(username) LIKE UPPER(:query) '
      'OR UPPER(site_address) LIKE UPPER(:query) '
      'ORDER BY username ASC')
  Stream<List<Vault>> fetchAllVaultsFromCategory(String category, String query);
}
