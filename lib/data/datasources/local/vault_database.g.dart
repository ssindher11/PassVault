// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorVaultDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$VaultDatabaseBuilder databaseBuilder(String name) =>
      _$VaultDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$VaultDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$VaultDatabaseBuilder(null);
}

class _$VaultDatabaseBuilder {
  _$VaultDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$VaultDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$VaultDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<VaultDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$VaultDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$VaultDatabase extends VaultDatabase {
  _$VaultDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  VaultDao? _vaultDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `vault` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `category` TEXT NOT NULL, `username` TEXT NOT NULL, `site_address` TEXT NOT NULL, `password_hash` TEXT NOT NULL, `is_favourite` INTEGER NOT NULL, `updated_at` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  VaultDao get vaultDao {
    return _vaultDaoInstance ??= _$VaultDao(database, changeListener);
  }
}

class _$VaultDao extends VaultDao {
  _$VaultDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _vaultInsertionAdapter = InsertionAdapter(
            database,
            'vault',
            (Vault item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'username': item.username,
                  'site_address': item.siteAddress,
                  'password_hash': item.passwordHash,
                  'is_favourite': item.isFavourite ? 1 : 0,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _vaultUpdateAdapter = UpdateAdapter(
            database,
            'vault',
            ['id'],
            (Vault item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'username': item.username,
                  'site_address': item.siteAddress,
                  'password_hash': item.passwordHash,
                  'is_favourite': item.isFavourite ? 1 : 0,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _vaultDeletionAdapter = DeletionAdapter(
            database,
            'vault',
            ['id'],
            (Vault item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'username': item.username,
                  'site_address': item.siteAddress,
                  'password_hash': item.passwordHash,
                  'is_favourite': item.isFavourite ? 1 : 0,
                  'updated_at': item.updatedAt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Vault> _vaultInsertionAdapter;

  final UpdateAdapter<Vault> _vaultUpdateAdapter;

  final DeletionAdapter<Vault> _vaultDeletionAdapter;

  @override
  Future<List<Vault>> _fetchAllVaults() async {
    return _queryAdapter.queryList('SELECT * FROM vault',
        mapper: (Map<String, Object?> row) => Vault(
            row['id'] as int?,
            row['category'] as String,
            row['username'] as String,
            row['site_address'] as String,
            row['password_hash'] as String,
            (row['is_favourite'] as int) != 0,
            row['updated_at'] as int?));
  }

  @override
  Stream<List<Vault>> fetchAllVaults(String query) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM vault WHERE UPPER(username) LIKE UPPER(?1) OR UPPER(site_address) LIKE UPPER(?1) ORDER BY username ASC',
        mapper: (Map<String, Object?> row) => Vault(
            row['id'] as int?,
            row['category'] as String,
            row['username'] as String,
            row['site_address'] as String,
            row['password_hash'] as String,
            (row['is_favourite'] as int) != 0,
            row['updated_at'] as int?),
        arguments: [query],
        queryableName: 'vault',
        isView: false);
  }

  @override
  Stream<List<Vault>> fetchAllVaultsOrderedByRecent(String query) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM vault WHERE UPPER(username) LIKE UPPER(?1) OR UPPER(site_address) LIKE UPPER(?1) ORDER BY updated_at DESC, username ASC',
        mapper: (Map<String, Object?> row) => Vault(
            row['id'] as int?,
            row['category'] as String,
            row['username'] as String,
            row['site_address'] as String,
            row['password_hash'] as String,
            (row['is_favourite'] as int) != 0,
            row['updated_at'] as int?),
        arguments: [query],
        queryableName: 'vault',
        isView: false);
  }

  @override
  Stream<List<Vault>> fetchAllVaultsIfFavourites(String query) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM vault WHERE is_favourite = true AND UPPER(username) LIKE UPPER(?1) OR UPPER(site_address) LIKE UPPER(?1) ORDER BY username ASC',
        mapper: (Map<String, Object?> row) => Vault(
            row['id'] as int?,
            row['category'] as String,
            row['username'] as String,
            row['site_address'] as String,
            row['password_hash'] as String,
            (row['is_favourite'] as int) != 0,
            row['updated_at'] as int?),
        arguments: [query],
        queryableName: 'vault',
        isView: false);
  }

  @override
  Stream<List<Vault>> fetchAllVaultsFromCategory(
    String category,
    String query,
  ) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM vault WHERE category = ?1 AND UPPER(username) LIKE UPPER(?2) OR UPPER(site_address) LIKE UPPER(?2) ORDER BY username ASC',
        mapper: (Map<String, Object?> row) => Vault(
            row['id'] as int?,
            row['category'] as String,
            row['username'] as String,
            row['site_address'] as String,
            row['password_hash'] as String,
            (row['is_favourite'] as int) != 0,
            row['updated_at'] as int?),
        arguments: [category, query],
        queryableName: 'vault',
        isView: false);
  }

  @override
  Future<int> addVault(Vault vault) {
    return _vaultInsertionAdapter.insertAndReturnId(
        vault, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateVault(Vault vault) {
    return _vaultUpdateAdapter.updateAndReturnChangedRows(
        vault, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteVault(Vault vault) async {
    await _vaultDeletionAdapter.delete(vault);
  }

  @override
  Future<void> _deleteVaults(List<Vault> vaults) async {
    await _vaultDeletionAdapter.deleteList(vaults);
  }

  @override
  Future<void> deleteAllVaults() async {
    if (database is sqflite.Transaction) {
      await super.deleteAllVaults();
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$VaultDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.vaultDao.deleteAllVaults();
      });
    }
  }
}
