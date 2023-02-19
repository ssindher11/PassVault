import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../res/res.dart';
import '../views/simple_app_bar.dart';

class GeneratePasswordPage extends StatelessWidget {
  GeneratePasswordPage({Key? key}) : super(key: key);
  static const initStringPool =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  final _password = List.generate(16, (index) {
    final indexRandom = Random.secure().nextInt(initStringPool.length);
    return initStringPool[indexRandom];
  }).join('').obs;
  final _passwordLength = 16.0.obs;
  final _includeNumbers = true.obs;
  final _includeUppercaseLetters = true.obs;
  final _includeLowercaseLetters = true.obs;
  final _includeSpecialSymbols = false.obs;
  final _minLength = 4.0;
  final _maxLength = 32.0;

  String get _passwordLengthValue => _passwordLength.round().toString();

  bool get _isPasswordValid =>
      _includeLowercaseLetters.value ||
      _includeUppercaseLetters.value ||
      _includeNumbers.value ||
      _includeSpecialSymbols.value;

  double _getLeftLabelDistance(BuildContext context) {
    return ((_passwordLength.value - _minLength) / (_maxLength - _minLength)) *
            (MediaQuery.of(context).size.width - 80) +
        (((_maxLength - _passwordLength.value) / _maxLength) * 20);
  }

  TextStyle _getMinMaxLabelTextStyle(double value) {
    return _passwordLength.value == value
        ? const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: darkTextColor,
          )
        : const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: greyTextColor,
          );
  }

  void _generatePassword() {
    const letterLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const letterUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';
    String charsPool = '';
    if (_includeLowercaseLetters.value) charsPool += letterLowerCase;
    if (_includeUppercaseLetters.value) charsPool += letterUpperCase;
    if (_includeNumbers.value) charsPool += number;
    if (_includeSpecialSymbols.value) charsPool += special;

    final password = List.generate(_passwordLength.value.toInt(), (index) {
      final indexRandom = Random.secure().nextInt(charsPool.length);
      return charsPool[indexRandom];
    }).join('');
    _password.value = password;
  }

  Widget _buildPasswordContainer(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              child: Text(
                _password.value,
                style: const TextStyle(
                  color: darkTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: !_isPasswordValid
                    ? null
                    : () {
                        Clipboard.setData(
                          ClipboardData(text: _password.value),
                        ).then((_) {
                          if (!GetPlatform.isAndroid) {
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard!'),
                                ),
                              );
                          }
                        });
                      },
                highlightElevation: 0,
                disabledElevation: 0,
                backgroundColor:
                    _isPasswordValid ? redPrimary : greyBorderColor,
                mini: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(16),
                    topStart: Radius.circular(16),
                  ),
                ),
                tooltip: 'Copy to clipboard',
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: const Icon(Icons.copy),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Password Length',
                  style: TextStyle(
                    color: darkTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SliderTheme(
                      data: const SliderThemeData(
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                        inactiveTrackColor: greyTrackColor,
                        activeTrackColor: lightOrange,
                      ),
                      child: Slider(
                        value: _passwordLength.value,
                        onChanged: (newValue) {
                          _passwordLength.value = newValue;
                          _generatePassword();
                        },
                        min: _minLength,
                        max: _maxLength,
                        divisions: (_maxLength - _minLength).toInt(),
                        thumbColor: redPrimary,
                      ),
                    ),
                  ),
                  Positioned(
                    left: _getLeftLabelDistance(context),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        (_passwordLength.value == _minLength ||
                                _passwordLength.value == _maxLength)
                            ? ''
                            : _passwordLengthValue,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: darkTextColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4',
                          style: _getMinMaxLabelTextStyle(_minLength),
                        ),
                        const Spacer(),
                        Text(
                          '32',
                          style: _getMinMaxLabelTextStyle(_maxLength),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Include:',
                  style: TextStyle(
                    color: darkTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Text(
                      'Numbers',
                      style: TextStyle(
                        color: greyTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _includeNumbers.value,
                      onChanged: (newValue) {
                        _includeNumbers.value = newValue;
                        _generatePassword();
                      },
                      activeColor: redPrimary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Text(
                      'Uppercase letters',
                      style: TextStyle(
                        color: greyTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _includeUppercaseLetters.value,
                      onChanged: (newValue) {
                        _includeUppercaseLetters.value = newValue;
                        _generatePassword();
                      },
                      activeColor: redPrimary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Text(
                      'Lowercase letters',
                      style: TextStyle(
                        color: greyTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _includeLowercaseLetters.value,
                      onChanged: (newValue) {
                        _includeLowercaseLetters.value = newValue;
                        _generatePassword();
                      },
                      activeColor: redPrimary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Text(
                      'Special symbols',
                      style: TextStyle(
                        color: greyTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _includeSpecialSymbols.value,
                      onChanged: (newValue) {
                        _includeSpecialSymbols.value = newValue;
                        _generatePassword();
                      },
                      activeColor: redPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: ElevatedButton(
                onPressed: !_isPasswordValid
                    ? null
                    : () {
                        Navigator.pop(context, _password.value);
                      },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      _isPasswordValid ? redPrimary : greyBorderColor,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    elevation:
                        MaterialStatePropertyAll(_isPasswordValid ? 2 : 0)),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: !_isPasswordValid ? null : () => _generatePassword(),
              backgroundColor: _isPasswordValid ? redPrimary : greyBorderColor,
              heroTag: null,
              disabledElevation: 0,
              tooltip: 'Regenerate',
              child: const Icon(Icons.cached),
            ),
          ],
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
                const SimpleAppBar(title: 'Generate Password'),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: _buildPasswordContainer(context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: _buildConfigurationSection(context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                        sliver: _buildButtonRow(context),
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
