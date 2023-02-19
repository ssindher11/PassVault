import 'package:pass_vault/domain/repositories/vault_repository.dart';

import '../../domain/entities/vault_model.dart';

class CreateVaultBloc {
  final VaultRepository vaultRepository;

  CreateVaultBloc(this.vaultRepository);

  Future<void> createVault(VaultModel vaultModel) async {
    await vaultRepository.addVault(vaultModel);
  }

  Future<void> updateVault(VaultModel vaultModel) async {
    await vaultRepository.updateVault(vaultModel);
  }
}
