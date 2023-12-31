import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_vault/presentation/views/simple_app_bar.dart';

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
  final _queryText = ''.obs;
  final _searchTextController = TextEditingController();

  @override
  void dispose() {
    _vaultBloc.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  Widget _buildAppBar() {
    return const SimpleAppBar(title: 'My Vaults');
  }

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

  Widget _buildVaultListItem(VaultModel vaultModel) {
    return Slidable(
      groupTag: '1',
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          FabSlidableAction(
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateVaultPage(
                    vaultModel: vaultModel,
                  ),
                ),
              );
            },
            backgroundColor: darkBlue,
            child: const Icon(Icons.edit_outlined),
          ),
          FabSlidableAction(
            onPressed: (context) {
              _vaultBloc.deleteVault(vaultModel);
            },
            backgroundColor: redPrimary,
            child: const Icon(Icons.delete_outline),
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
        return _vaultBloc.getAllVaultsStream(query: _queryText.value);

      case 1:
        return _vaultBloc.getRecentVaultsStream(query: _queryText.value);

      case 2:
        return _vaultBloc.getFavouriteVaultsStream(query: _queryText.value);

      default:
        return _vaultBloc.getAllVaultsStream(query: _queryText.value);
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
                _buildAppBar(),
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
          )
        ],
      ),
    );
  }
}
