import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_vault/injection.dart';
import 'package:pass_vault/presentation/bloc/category_vault_bloc.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/vault_model.dart';
import '../../external/flutter_slidable/flutter_slidable.dart';
import '../../res/res.dart';
import '../views/no_items_container.dart';
import '../views/vault_list_item.dart';
import '../views/simple_app_bar.dart';
import 'create_vault_page.dart';

class CategoryVaultsPage extends StatelessWidget {
  CategoryVaultsPage({
    required this.category,
    Key? key,
  }) : super(key: key);

  final Category category;

  final CategoryVaultBloc _vaultBloc = locator<CategoryVaultBloc>();

  final _queryText = ''.obs;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return SliverToBoxAdapter(
      child: TextField(
        controller: _searchTextController,
        onChanged: (newText) => _queryText.value = newText,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
          hintText: 'Search your vaults',
          hintStyle: const TextStyle(color: greyTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: redPrimary),
            borderRadius: BorderRadius.circular(16),
          ),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: greyTextColor,
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(color: darkTextColor),
        cursorColor: darkTextColor,
        autocorrect: false,
      ),
    );
  }

  Widget _buildNoItemsContainer() {
    return SliverToBoxAdapter(
      child: NoItemsContainer(
        message: "No vaults added to\n${category.value}",
      ),
    );
  }

  Widget _buildVaultListItem(BuildContext context, VaultModel vaultModel) {
    return Slidable(
      groupTag: '1',
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.35,
        children: [
          CustomSlidableAction(
            onPressed: null,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            autoClose: true,
            child: FloatingActionButton.small(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateVaultPage(
                      vaultModel: vaultModel,
                    ),
                  ),
                );
                // slidableKey.currentState?.controller.close();
              },
              backgroundColor: darkBlue,
              child: const Icon(Icons.edit_outlined),
            ),
          ),
          CustomSlidableAction(
            onPressed: null,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            autoClose: false,
            child: FloatingActionButton.small(
              onPressed: () {
                // slidableKey.currentState?.controller.close();
                _vaultBloc.deleteVault(vaultModel);
              },
              backgroundColor: redPrimary,
              child: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
      child: VaultListItem(
        vaultModel: vaultModel,
        onFavouriteClick: () => _vaultBloc.toggleVaultIsFavourite(vaultModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return SimpleAppBar(title: category.value);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.fromSize(
            size: Size.infinite,
            child: Image.asset(
              lightBackdrop,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                SimpleAppBar(title: category.value),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: _buildSearchField(),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        sliver: SlidableAutoCloseBehavior(
                          child: Obx(
                            () => StreamBuilder(
                              stream: _vaultBloc.getCategoryVaults(
                                category: category,
                                query: _queryText.value,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  final vaultList = snapshot.data ?? [];
                                  if (vaultList.isNotEmpty) {
                                    return SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) => _buildVaultListItem(
                                          context,
                                          vaultList[index],
                                        ),
                                        childCount: snapshot.data?.length ?? 0,
                                      ),
                                    );
                                  } else {
                                    return _buildNoItemsContainer();
                                  }
                                } else {
                                  return _buildNoItemsContainer();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
