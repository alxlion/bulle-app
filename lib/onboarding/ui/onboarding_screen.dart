import 'package:bulle/components/inputs/primary_button.dart';
import 'package:bulle/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  void _requestContacts() async {
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      List<Contact> contacts = await FlutterContacts.getContacts();

      // Get all contacts (fully fetched)
      contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);

      print(contacts.length);

      // Listen to contact database changes
      FlutterContacts.addListener(() => print('Contact DB changed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
          child: PageView(
        controller: _controller,
        children: [
          Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Column(
                        children: [
                          Text(
                            "You feel alone ?",
                            style: TextStyle(
                                fontFamily: 'Viking', fontWeight: FontWeight.w700, color: Colors.black, fontSize: 50),
                          ),
                          Text(
                            "Sometimes loneliness is essential, but often destructive in the long run.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )
                        ],
                      ),
                      Image.asset(
                        'assets/img/onb1.png',
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              backgroundColor: Colors.black,
                              onPressed: () {
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);
                              },
                              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text("Next",
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward, color: Colors.white)
                              ]),
                            ),
                          ),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Back",
                                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.black)))
                        ],
                      )
                    ],
                  ))),
          Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Column(
                        children: [
                          Text(
                            "Talk whenever you feel to.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Viking',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 50,
                                height: 1),
                          ),
                          Text(
                            "Enter your bubble when you are available to talk.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )
                        ],
                      ),
                      Image.asset(
                        'assets/img/onb2.png',
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);
                          },
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text("Next",
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, color: Colors.white)
                          ]),
                        ),
                      ),
                    ],
                  ))),
          Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Column(
                        children: [
                          Text(
                            "Only those you care about.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Viking',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 50,
                                height: 1),
                          ),
                          Text(
                            "Only your friends can enter your bubble and talk with.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )
                        ],
                      ),
                      Image.asset(
                        'assets/img/onb3.png',
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            _requestContacts();
                          },
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text("Show my friend's bubbles",
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                            SizedBox(width: 10),
                            Icon(Icons.contacts, color: Colors.white)
                          ]),
                        ),
                      ),
                    ],
                  )))
        ],
      )),
    );
  }
}
