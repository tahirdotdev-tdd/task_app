import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final int _pageCount = 4;

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == _pageCount - 1;
            });
          },
          children: const [
            OnboardPage(
              color: Colors.teal,
              iconData: Icons.checklist_rtl_rounded,
              title: "Welcome to T4TASK",
              description:
                  "Your personal space to conquer chaos and organize your day, one task at a time.",
            ),
            OnboardPage(
              color: Colors.blue,
              iconData: Icons.edit_note_rounded,
              title: "Manage Tasks With Ease",
              description:
                  "Quickly add, update, and mark tasks as complete. Stay in full control of your to-do list.",
            ),
            OnboardPage(
              color: Colors.orange,
              iconData: Icons.notifications_active_rounded,
              title: "Never Miss a Beat",
              description:
                  "Set reminders and get timely notifications. Deleted a task? No problem! Restore it from the trash.",
            ),
            OnboardPage(
              color: Colors.deepPurple,
              iconData: Icons.brightness_6_rounded,
              title: "Make It Yours",
              description:
                  "Switch between light and dark modes for your comfort. Ready to boost your productivity?",
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: completeOnboarding,
              child: const Text("Skip"),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _pageCount,
              effect: WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotColor: Colors.grey.shade300,
              ),
            ),
            isLastPage
                ? TextButton(
                    onPressed: completeOnboarding,
                    child: const Text("Done"),
                  )
                : TextButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text("Next"),
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
  final IconData iconData;
  final Color color;

  const OnboardPage({
    super.key,
    required this.title,
    required this.description,
    required this.iconData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: color, size: 80),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
