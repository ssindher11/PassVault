import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_vault/domain/entities/vault_model.dart';
import 'package:pass_vault/injection.dart';
import 'package:pass_vault/presentation/bloc/create_vault_bloc.dart';
import 'package:pass_vault/res/images.dart';

import '../../domain/usecases/get_favicon_use_case.dart';
import '../../res/color.dart';
import '../../utils/debouncer.dart';

class CreateVaultPage extends StatefulWidget {
  const CreateVaultPage({Key? key}) : super(key: key);

  @override
  State<CreateVaultPage> createState() => _CreateVaultPageState();
}

class _CreateVaultPageState extends State<CreateVaultPage> {
  final IGetFaviconUseCase getFaviconUseCase = GetFaviconUseCase();
  final CreateVaultBloc _createVaultBloc = locator<CreateVaultBloc>();

  final _siteAddress = ''.obs;
  final _siteAddressController = TextEditingController();
  final _siteAddressDebouncer = Debouncer(milliseconds: 500);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? usernameError;
  String? siteAddressError;
  String? passwordError;

  final _categoriesList = ["Browser", "Mobile app", "Payment"];
  String? _selectedCategory = "Browser";

  final _obscureText = true.obs;

  _CreateVaultPageState() {
    _selectedCategory = _categoriesList[0];
  }

  @override
  void initState() {
    super.initState();
    _siteAddressController.addListener(() {
      _siteAddressDebouncer.run(() {
        _siteAddress.value = _siteAddressController.text;
      });
    });
  }

  @override
  void dispose() {
    _siteAddressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _siteAddressDebouncer.dispose();
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
              'Create New Vault',
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

  Widget _buildCredentialSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Credential',
            style: TextStyle(
              color: darkTextColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Category',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: greyTextColor,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField(
            items: _categoriesList
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: (selectedValue) {
              _selectedCategory = selectedValue;
              setState(() {});
            },
            value: _selectedCategory,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: greyBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: redPrimary),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Site Address',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: greyTextColor,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _siteAddressController,
            onChanged: (_) => setState(() { siteAddressError = null; }),
            maxLines: 1,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                hintText: 'snapchat.com',
                hintStyle: const TextStyle(color: greyTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: greyBorderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: redPrimary),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.link),
                filled: true,
                fillColor: Colors.white,
                errorText: siteAddressError),
            style: const TextStyle(color: darkTextColor),
            cursorColor: darkTextColor,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          const Text(
            'User Name',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: greyTextColor,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _usernameController,
            onChanged: (_) => setState(() { usernameError = null; }),
            maxLines: 1,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                hintText: '@john.doe',
                hintStyle: const TextStyle(color: greyTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: greyBorderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: redPrimary),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person_2_outlined),
                filled: true,
                fillColor: Colors.white,
                errorText: usernameError),
            style: const TextStyle(color: darkTextColor),
            cursorColor: darkTextColor,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          const Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: greyTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => TextField(
                    controller: _passwordController,
                    onChanged: (_) => setState(() { passwordError = null; }),
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                      hintText: '●●●●●●●●●●●●',
                      hintStyle: const TextStyle(color: greyTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyBorderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: redPrimary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: passwordError,
                      suffix: InkWell(
                        onTap: () {
                          _obscureText.value = !_obscureText.value;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: lightOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _obscureText.value ? 'View' : 'Hide',
                            style: const TextStyle(
                              color: redPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    style: const TextStyle(color: darkTextColor),
                    cursorColor: darkTextColor,
                    obscureText: _obscureText.value,
                    obscuringCharacter: '●',
                  ),
                ),
              ),
              const SizedBox(width: 4),
              FloatingActionButton.small(
                onPressed: () {},
                backgroundColor: redPrimary,
                heroTag: null,
                tooltip: 'Generate Password',
                child: const Icon(Icons.cached),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*Widget _buildAddTagsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Tag',
            style: TextStyle(
              color: darkTextColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          // TODO: Change chip logic
          Wrap(
            spacing: 6,
            children: [
              ChoiceChip(
                label: Text(
                  'Design',
                  style: TextStyle(
                    color: isChipSelected ? Colors.white : redPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: lightOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                selected: isChipSelected,
                onSelected: (isSelected) => setState(() {
                  isChipSelected = isSelected;
                }),
                selectedColor: redPrimary,
              ),
              ActionChip(
                label: const Text(
                  'Add +',
                  style: TextStyle(
                    color: Color(0xFF47495B),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: lightBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }*/

  void _createVault() {
    String username = _usernameController.text;
    String siteAddress = _siteAddressController.text;
    String password = _passwordController.text;
    if (username.isNotEmpty && siteAddress.isNotEmpty && password.isNotEmpty) {
      VaultModel vaultModel = VaultModel(
        category: _selectedCategory ?? 'Browser',
        username: _usernameController.text,
        siteAddress: _siteAddressController.text,
        passwordHash: _passwordController.text,
        isFavourite: false,
      );
      _createVaultBloc.createVault(vaultModel).then((_) => Navigator.pop(context));
    } else {
      usernameError = username.isEmpty ? 'Enter username' : null;
      siteAddressError = siteAddress.isEmpty ? 'Enter website/app name' : null;
      passwordError = password.isEmpty ? 'Enter password' : null;
      setState(() {});
    }
  }

  var isChipSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
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
                        padding: const EdgeInsets.only(top: 20),
                        sliver: SliverToBoxAdapter(
                          child: Obx(
                            () => _siteAddress.isNotEmpty
                                ? Align(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      height: 64,
                                      width: 64,
                                      padding: const EdgeInsets.all(12),
                                      child: Image.network(
                                        getFaviconUseCase
                                            .execute(_siteAddress.value),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _buildCredentialSection(),
                      ),
                      /*SliverToBoxAdapter(
                        child: _buildAddTagsSection(),
                      ),*/
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 24, bottom: 32),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              onPressed: _createVault,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(redPrimary),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Create the vault',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
