
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:system_auth/screens/onboarding/auth_buttons.dart';
import 'package:system_auth/screens/onboarding/info/intro_1.dart';
import 'package:system_auth/screens/onboarding/info/intro_2.dart';
import 'package:system_auth/screens/onboarding/info/intro_3.dart';
import 'package:system_auth/screens/onboarding/info/intro_4.dart';
import 'package:system_auth/screens/onboarding/info/intro_5.dart';
import 'package:system_auth/themes/theme_toggle.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  final ValueNotifier<int> _currentPageIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _currentPageIndex.value = _pageController.page!.round();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AuthPageDecoration(),
          Align(
            alignment: Alignment(0, -0.6),
            child: PageView(
              controller: _pageController,
              children: [
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
                IntroPage4(),
                IntroPage5(),
              ],
            ),
          ),

          // dot indicator WAP
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 40.0),
              constraints: BoxConstraints(maxWidth: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Skip/Back button
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPageIndex,
                    builder: (context, value, child) {
                      return AuthButtonSecondary(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 0.0),
                        onPressed: () {
                          if (value == 4) {
                            // If on the last page, navigate to the first page
                            _pageController.animateToPage(
                              0, // Navigate to the first page
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // If not on the last page, navigate to the last page
                            _pageController.animateToPage(
                              4, // Navigate to the last page
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        text: value == 4 ? 'Restart' : 'Skip',
                      );
                    },
                  ),
            
                  SmoothPageIndicator(
                      controller: _pageController,
                      count: 5,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Colors.brown,
                        dotHeight: 12,
                        dotWidth: 12,
                        spacing: 8,
                        expansionFactor: 2,
                      )),
            
                  // Next or Get Started button
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPageIndex,
                    builder: (context, value, child) {
                      return AuthButtonPrimary(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 0.0),
                        onPressed: () {
                          if (value == 4) {
                            // Navigate to the next screen (e.g., main app screen)
                            // Replace this with your navigation logic
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogIn()),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        text: value == 4 ? 'Get Started' : 'Next',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            left: 20.0,
            child: ThemeToggle(),
          ),
        ],
      ),
    );
  }
}

class AuthPageDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(
          //       'assets/images/bg_decorate.webp',
          //     ),
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
          ),
        ),
      ],
    );
  }
}
