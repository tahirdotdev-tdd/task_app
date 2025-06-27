import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../screens/home_page.dart'; // Make sure this path is correct for your project

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  final int _pageCount = 4; // We now have 4 pages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Space for the bottom sheet
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              // The last page index is now 3
              isLastPage = index == _pageCount - 1;
            });
          },
          // ✅ A list of visually rich onboarding pages
          children: const [
            OnboardPage(
              color: Colors.teal,
              iconData: Icons.checklist_rtl_rounded,
              title: "Welcome to T4TASK",
              description: "Your personal space to conquer chaos and organize your day, one task at a time.",
            ),
            OnboardPage(
              color: Colors.blue,
              iconData: Icons.edit_note_rounded,
              title: "Manage Tasks With Ease",
              description: "Quickly add, update, and mark tasks as complete. Stay in full control of your to-do list.",
            ),
            OnboardPage(
              color: Colors.orange,
              iconData: Icons.notifications_active_rounded,
              title: "Never Miss a Beat",
              description: "Set reminders and get timely notifications. Deleted a task? No problem! Restore it from the trash.",
            ),
            OnboardPage(
              color: Colors.deepPurple,
              iconData: Icons.brightness_6_rounded,
              title: "Make It Yours",
              description: "Switch between light and dark modes for your comfort. Ready to boost your productivity?",
            ),
          ],
        ),
      ),
      // ✅ The bottom sheet controls the flow
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Skip Button
            TextButton(
              onPressed: () {
                // Navigate directly to home page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text("Skip"),
            ),

            // Page Indicator
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: _pageCount,
                effect: WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),

            // Next / Done Button
            isLastPage
                ? TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
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

// ✅ A completely redesigned, more powerful OnboardPage widget
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
          // Visually appealing icon container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: color,
              size: 80,
            ),
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