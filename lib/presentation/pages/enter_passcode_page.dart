import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pass_vault/res/res.dart';

class EnterPasscodePage extends StatefulWidget {
  const EnterPasscodePage({Key? key}) : super(key: key);

  @override
  State<EnterPasscodePage> createState() => _EnterPasscodePageState();
}

class _EnterPasscodePageState extends State<EnterPasscodePage> {
  List<Alignment> alignmentList = [
    Alignment.topLeft,
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
  ];

  final index = 0.obs;

  final bottomColor = const Color(0xFF2C5364).obs;

  final topColor = const Color(0xFF0F2027).obs;

  final begin = Alignment.topLeft.obs;

  final end = Alignment.bottomRight.obs;

  void _onNumPress(int num) {
    index.value += 1;
    begin.value = alignmentList[index.value % alignmentList.length];
    end.value = alignmentList[(index.value + 2) % alignmentList.length];
  }

  void _onDeletePress() {
    index.value -= 1;
    begin.value = alignmentList[index.value % alignmentList.length];
    end.value = alignmentList[(index.value + 2) % alignmentList.length];
  }

  Widget _buildLockIconSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top) *
            0.35,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              color: Colors.white,
              size: 48,
            ),
            SizedBox(height: 24),
            Text(
              'Enter your passcode',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumber({int? num, bool isDelete = false}) {
    return InkWell(
      onTap: () => isDelete ? _onDeletePress() : _onNumPress(num!),
      customBorder: const CircleBorder(),
      child: Center(
        child: isDelete
            ? const Icon(Icons.backspace, color: Colors.white)
            : Text(
                num.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin.value,
            end: end.value,
            colors: [
              bottomColor.value,
              const Color(0xFF203A43),
              topColor.value,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      _buildLockIconSection(context),
                      const SliverToBoxAdapter(
                        child: Divider(
                          indent: 20,
                          endIndent: 20,
                          color: greyBorderColor,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          top: 20,
                          right: 40,
                        ),
                        sliver: SliverGrid.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                          children: [
                            ...[for (var i = 1; i <= 9; i++) i]
                                .map((e) => _buildNumber(num: e)),
                            _buildNumber(isDelete: true),
                            _buildNumber(num: 0),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
