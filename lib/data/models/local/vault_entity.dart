import 'package:floor/floor.dart';

@Entity(tableName: 'vault')
class Vault {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String category;
  final String username;
  @ColumnInfo(name: 'site_address')
  final String siteAddress;
  @ColumnInfo(name: 'password_hash')
  final String passwordHash;
  @ColumnInfo(name: 'is_favourite')
  final bool isFavourite;
  @ColumnInfo(name: 'updated_at')
  final int? updatedAt;

  Vault(
    this.id,
    this.category,
    this.username,
    this.siteAddress,
    this.passwordHash,
    this.isFavourite,
    this.updatedAt,
  );

  factory Vault.optional({
    int? id,
    required String category,
    required String username,
    required String siteAddress,
    required String passwordHash,
    bool? isFavourite,
    int? updatedAt,
  }) =>
      Vault(
        id,
        category,
        username,
        siteAddress,
        passwordHash,
        isFavourite ?? false,
        updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      );
}
