import 'package:flutter/material.dart';
import 'package:pass_vault/presentation/pages/create_vault_page.dart';
import 'package:pass_vault/presentation/pages/enter_passcode_page.dart';
import 'package:pass_vault/presentation/views/greeting.dart';
import 'package:pass_vault/res/color.dart';
import 'package:pass_vault/res/images.dart';

import 'home_page_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              homeBackdrop,
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 4, right: 20, bottom: 20),
                  child: Row(
                    children: [
                      const Greeting(name: 'Shrey'),
                      const Spacer(),
                      FloatingActionButton.small(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EnterPasscodePage()),
                          );
                        },
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        heroTag: null,
                        child: const Icon(Icons.settings_outlined),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: HomePageContainer()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
