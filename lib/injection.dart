import 'package:get/get.dart';
import 'package:pass_vault/data/datasources/local/vault_dao.dart';
import 'package:pass_vault/data/datasources/local/vault_database.dart';
import 'package:pass_vault/data/repositories/vault_repository_impl.dart';
import 'package:pass_vault/domain/repositories/vault_repository.dart';
import 'package:pass_vault/domain/usecases/get_favicon_use_case.dart';

void setupDI() {
  Get.putAsync<VaultDatabase>(
    () async {
      return await $FloorVaultDatabase
          .databaseBuilder('vault_database.db')
          .build();
    },
    permanent: true,
  );

  VaultDao vaultDao = Get.put<VaultDao>(Get.find<VaultDatabase>().vaultDao);

  Get.put<IGetFaviconUseCase>(GetFaviconUseCase());

  Get.put<VaultRepository>(VaultRepositoryImpl(vaultDao: vaultDao));
}
