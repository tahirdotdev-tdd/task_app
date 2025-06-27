import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../screens/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: const [
            OnboardPage(title: "Welcome", description: "Welcome to the app!"),
            OnboardPage(title: "Explore", description: "Explore the features!"),
            OnboardPage(
              title: "Get Started",
              description: "Get started with your tasks!",
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (contexxt) => const HomePage()));
              },
              child: Text("Skip"),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
            isLastPage
                ? TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },

                    child: Text("Done"),
                  )
                : TextButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: Duration(microseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text("Next"),
                  ),
          ],
        ),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final String title;
  final String description;
  // final String imageAsset;

  const OnboardPage({
    super.key,
    required this.title,
    required this.description,
    // required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset(imageAsset, height: 250),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
