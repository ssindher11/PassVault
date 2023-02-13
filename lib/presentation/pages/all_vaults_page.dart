import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_vault/presentation/views/custom_choice_chip.dart';

import '../../domain/usecases/get_favicon_use_case.dart';
import '../../res/res.dart';

class AllVaultsPage extends StatefulWidget {
  const AllVaultsPage({Key? key}) : super(key: key);

  @override
  State<AllVaultsPage> createState() => _AllVaultsPageState();
}

class _AllVaultsPageState extends State<AllVaultsPage> {
  final IGetFaviconUseCase _getFaviconUseCase = GetFaviconUseCase();
  final _selectedIndex = 0.obs;
  final _chipChoicesList = ["All", "Recent", "Favourite"];

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
                onSelected: () {
                  _selectedIndex.value = index;
                },
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

  @override
  Widget build(BuildContext context) {
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
