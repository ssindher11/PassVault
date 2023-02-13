import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/vault_model.dart';
import '../../external/flutter_slidable/flutter_slidable.dart';
import '../../injection.dart';
import '../../res/res.dart';
import '../bloc/vault_bloc.dart';
import '../views/custom_choice_chip.dart';
import '../views/no_items_container.dart';
import '../views/vault_list_item.dart';
import 'create_vault_page.dart';

class AllVaultsPage extends StatefulWidget {
  const AllVaultsPage({Key? key}) : super(key: key);

  @override
  State<AllVaultsPage> createState() => _AllVaultsPageState();
}

class _AllVaultsPageState extends State<AllVaultsPage> {
  final VaultBloc _vaultBloc = locator<VaultBloc>();

  final _selectedIndex = 0.obs;
  final _chipChoicesList = ["All", "Recent", "Favourite"];

  @override
  void initState() {
    super.initState();
    _vaultBloc.fetchAllVaults();
    _vaultBloc.fetchAllVaultsOrderedByRecent();
    _vaultBloc.fetchAllVaultsIfFavourites();
  }

  @override
  void dispose() {
    _vaultBloc.dispose();
    super.dispose();
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FloatingActionButton.small(
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.white,
              foregroundColor: darkBlue,
              child: const Icon(Icons.arrow_back),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'My Vaults',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildChoiceChipRow() {
    return SliverToBoxAdapter(
      child: Obx(
        () => Flex(
          direction: Axis.horizontal,
          children: List.generate(_chipChoicesList.length, (index) {
            bool isChipSelected = index == _selectedIndex.value;
            final EdgeInsets chipMargin;
            if (index == 0) {
              chipMargin = const EdgeInsets.only(right: 4);
            } else if (index == _chipChoicesList.length - 1) {
              chipMargin = const EdgeInsets.only(left: 4);
            } else {
              chipMargin = const EdgeInsets.symmetric(horizontal: 4);
            }
            return Expanded(
              flex: 1,
              child: CustomChoiceChip(
                label: Text(
                  _chipChoicesList[index],
                  style: TextStyle(
                    color: isChipSelected ? Colors.white : darkBlue,
                  ),
                ),
                backgroundColor: Colors.white,
                selectedColor: redPrimary,
                selected: isChipSelected,
                onSelected: () => _selectedIndex.value = index,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                chipMargin: chipMargin,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNoItemsContainer() {
    return const SliverToBoxAdapter(
      child: NoItemsContainer(
        message: "Click on '+'\nto add vaults",
      ),
    );
  }

  Widget _buildVaultListItem(BuildContext ctx, VaultModel vaultModel) {
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

  Stream<List<VaultModel>> _getStream() {
    switch (_selectedIndex.value) {
      case 0:
        return _vaultBloc.allVaultsList;

      case 1:
        return _vaultBloc.recentVaultsList;

      case 2:
        return _vaultBloc.favouriteVaultsList;

      default:
        return _vaultBloc.allVaultsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateVaultPage()),
          );
        },
        backgroundColor: redPrimary,
        heroTag: null,
        child: const Icon(Icons.add),
      ),
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
                _buildAppBar(context),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: _buildSearchField(),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: _buildChoiceChipRow(),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        sliver: SlidableAutoCloseBehavior(
                          child: Obx(
                            () => StreamBuilder(
                              stream: _getStream(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  final vaultList = snapshot.data ?? [];
                                  if (vaultList.isNotEmpty) {
                                    return SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) => _buildVaultListItem(
                                            context, vaultList[index]),
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
          )
        ],
      ),
    );
  }
}
