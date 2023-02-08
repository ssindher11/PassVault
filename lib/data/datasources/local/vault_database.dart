import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:pass_vault/data/datasources/local/vault_dao.dart';

import '../../models/local/vault_entity.dart';
part 'vault_database.g.dart';

@Database(version: 1, entities: [Vault])
abstract class VaultDatabase extends FloorDatabase {
  VaultDao get vaultDao;
}
