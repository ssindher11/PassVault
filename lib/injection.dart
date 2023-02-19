import 'package:get_it/get_it.dart';
import 'package:pass_vault/data/datasources/local/vault_dao.dart';
import 'package:pass_vault/data/datasources/local/vault_database.dart';
import 'package:pass_vault/data/repositories/vault_repository_impl.dart';
import 'package:pass_vault/domain/repositories/vault_repository.dart';
import 'package:pass_vault/domain/usecases/get_favicon_use_case.dart';
import 'package:pass_vault/presentation/bloc/category_vault_bloc.dart';
import 'package:pass_vault/presentation/bloc/create_vault_bloc.dart';
import 'package:pass_vault/presentation/bloc/vault_bloc.dart';

final locator = GetIt.instance;

void setupDI() {
  locator.registerSingletonAsync<VaultDatabase>(() async {
    return await $FloorVaultDatabase
        .databaseBuilder('vault_database.db')
        .build();
  });

  locator.registerSingletonWithDependencies<VaultDao>(
    () => locator<VaultDatabase>().vaultDao,
    dependsOn: [VaultDatabase],
  );

  locator.registerFactory<IGetFaviconUseCase>(() => GetFaviconUseCase());

  locator.registerSingletonWithDependencies<VaultRepository>(
    () => VaultRepositoryImpl(vaultDao: locator()),
    dependsOn: [VaultDao],
  );

  locator.registerFactory(() => VaultBloc(locator()));

  locator.registerFactory(() => CreateVaultBloc(locator()));

  locator.registerFactory(() => CategoryVaultBloc(locator()));
}
