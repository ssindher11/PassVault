import 'package:flutter/material.dart';
import 'package:pass_vault/domain/entities/vault_model.dart';
import 'package:pass_vault/injection.dart';
import 'package:pass_vault/presentation/bloc/vault_bloc.dart';
import 'package:pass_vault/presentation/pages/all_vaults_page.dart';
import 'package:pass_vault/presentation/views/category_row.dart';
import 'package:pass_vault/presentation/views/vault_list_item.dart';
import 'package:pass_vault/res/res.dart';

import 'package:pass_vault/external/flutter_slidable/flutter_slidable.dart';

import '../views/no_items_container.dart';

class HomePageContainer extends StatefulWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  @override
  State<HomePageContainer> createState() => _HomePageContainerState();
}

class _HomePageContainerState extends State<HomePageContainer> {
  final VaultBloc _vaultBloc = locator<VaultBloc>();

  @override
  void initState() {
    super.initState();
    _vaultBloc.fetchAllVaultsOrderedByRecent();
  }

  @override
  void dispose() {
    _vaultBloc.dispose();
    super.dispose();
  }

  Widget _buildSearchField() {
    return SliverToBoxAdapter(
      child: TextField(
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
      ),
    );
  }

  Widget _buildNoItemsContainer() {
    return const NoItemsContainer(message: "Click on '+'\nto get started",);
  }

  Widget _buildRecentlyUsedRow(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Recently Used',
          style: TextStyle(
            color: darkTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllVaultsPage()),
            );
          },
          child: const Text(
            'See More',
            style: TextStyle(
              color: greyTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildVaultListItem(BuildContext ctx, VaultModel vaultModel) {
    final slidableKey = GlobalKey<SlidableState>();

    return Slidable(
      key: slidableKey,
      groupTag: '0',
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.35,
        children: [
          CustomSlidableAction(
            onPressed: (c) {},
            backgroundColor: lightBg,
            foregroundColor: lightBg,
            autoClose: true,
            child: FloatingActionButton.small(
              onPressed: () {
                slidableKey.currentState?.controller.close();
              },
              backgroundColor: darkBlue,
              child: const Icon(Icons.edit_outlined),
            ),
          ),
          CustomSlidableAction(
            onPressed: null,
            backgroundColor: lightBg,
            foregroundColor: lightBg,
            autoClose: false,
            child: FloatingActionButton.small(
              onPressed: () {
                slidableKey.currentState?.controller.close();
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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: StreamBuilder(
        stream: _vaultBloc.recentVaultsList,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final vaultList = snapshot.data!;
            if (vaultList.isNotEmpty) {
              _vaultBloc.updateCategoryCount();
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                    sliver: _buildSearchField(),
                  ),
                  SliverPadding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                    sliver: SliverToBoxAdapter(
                      child: StreamBuilder(
                        stream: _vaultBloc.categoryCount,
                        builder: (context, snapshot) {
                          return CategoryRow(
                            categoryCount: snapshot.data ?? {},
                            onCategoryClick: (category) {},
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                    sliver: SliverToBoxAdapter(
                      child: _buildRecentlyUsedRow(context),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    sliver: SlidableAutoCloseBehavior(
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildVaultListItem(context, vaultList[index]),
                          childCount: snapshot.data?.length ?? 0,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return _buildNoItemsContainer();
            }
          } else {
            return _buildNoItemsContainer();
          }
        },
      ),
    );
  }
}
