import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pass_vault/presentation/views/category_row.dart';
import 'package:pass_vault/presentation/views/vault_list_item.dart';
import 'package:pass_vault/res/color.dart';

import 'create_vault_page.dart';

class HomePageContainer extends StatelessWidget {
  const HomePageContainer({Key? key}) : super(key: key);

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
              MaterialPageRoute(builder: (context) => const CreateVaultPage()),
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

  Widget _buildVaultList(BuildContext context) {
    // TODO: Implement actual list
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.35,
        children: [
          CustomSlidableAction(
            onPressed: null,
            backgroundColor: lightBg,
            foregroundColor: lightBg,
            autoClose: false,
            child: FloatingActionButton.small(
              onPressed: () {},
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
              onPressed: () {},
              backgroundColor: redPrimary,
              child: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
      child: VaultListItem(),
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
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            sliver: _buildSearchField(),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: CategoryRow(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: _buildRecentlyUsedRow(context),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            sliver: SliverToBoxAdapter(
              child: _buildVaultList(context),
            ),
          ),
        ],
      ),
    );
  }
}
