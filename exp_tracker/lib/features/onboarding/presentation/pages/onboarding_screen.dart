import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Expense Tracker',
      description: 'Your simple and powerful companion to manage your personal finances effectively.',
      image: 'assets/images/a1.png',
    ),
    OnboardingData(
      title: 'Track Transactions',
      description: 'Easily log your daily income and expenses. Categories and tags help you stay organized.',
      image: 'assets/images/b1.png',
    ),
    OnboardingData(
      title: 'Insights & Reports',
      description: 'Visualize your spending habits with intuitive charts and reports to save more money.',
      image: 'assets/images/c1.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onDone();
    }
  }

  void _onSkip() {
    _onDone();
  }

  void _onDone() {
    context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      safeArea: false, // Handle safe area manually for better control
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation / Indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 10,
                        width: _currentPage == index ? 24 : 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _onSkip,
                    child: const AppText(
                      'Skip', 
                      color: AppColors.primary, 
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Content Area (Image + Text)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Responsive image container
                        Flexible(
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 220),
                            child: Image.asset(
                              _pages[index].image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? AppColors.surfaceDark : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        AppText(
                          _pages[index].title,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.textHeaderDark : AppColors.textHeaderLight,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        AppText(
                          _pages[index].description,
                          fontSize: 16,
                          color: isDarkMode ? AppColors.textBodyDark : AppColors.textBodyLight,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Continue Button at bottom
            Padding(
              padding: const EdgeInsets.all(30),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: AppText(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}
