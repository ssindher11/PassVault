import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final _siteAddress = ''.obs;
  final _siteAddressController = TextEditingController();
  final _siteAddressDebouncer = Debouncer(milliseconds: 500);

  final _categoriesList = ["Browser", "Mobile App", "Payment"];
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
            ),
            style: const TextStyle(color: darkTextColor),
            cursorColor: darkTextColor,
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
            ),
            style: const TextStyle(color: darkTextColor),
            cursorColor: darkTextColor,
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
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Obx(
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
                      _buildCredentialSection(),

                      // Bottom section
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(redPrimary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
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
                      const SizedBox(height: 32),
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
