import 'category.dart';

class VaultModel {
  final int? id;
  final Category category;
  final String username;
  final String siteAddress;
  final String passwordHash;
  final bool isFavourite;
  final int? updatedAt;

  VaultModel({
    this.id,
    required this.category,
    required this.username,
    required this.siteAddress,
    required this.passwordHash,
    required this.isFavourite,
    this.updatedAt,
  });
}
