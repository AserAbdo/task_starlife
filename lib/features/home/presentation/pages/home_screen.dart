import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_background.dart';

/// Home screen shown after successful login
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Card
                      _buildWelcomeCard(),

                      const SizedBox(height: 24),

                      // Quick Actions
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickActions(),

                      const SizedBox(height: 24),

                      // Recent Activity
                      const Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildServicesList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Logo
          Hero(
            tag: 'logo',
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold30,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset('assets/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Star Life',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryGold),
                ),
              ],
            ),
          ),
          // Notification button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.gold40,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.deepPurple20,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.verified_user,
                  color: AppColors.deepPurple,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login Successful!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'You are now connected to Star Life',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.deepPurple15,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: AppColors.deepPurple, size: 18),
                SizedBox(width: 8),
                Text(
                  'Premium Member',
                  style: TextStyle(
                    color: AppColors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.code,
            title: 'Development',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.campaign,
            title: 'Marketing',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.design_services,
            title: 'Design',
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    // Create opacity variants for the color
    final colorWithOpacity20 = Color.fromRGBO(
      color.r.toInt(),
      color.g.toInt(),
      color.b.toInt(),
      0.2,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white10),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorWithOpacity20,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    final services = [
      {
        'icon': Icons.phone_android,
        'title': 'Mobile App Development',
        'subtitle': 'Flutter, iOS, Android',
        'color': Colors.cyan,
      },
      {
        'icon': Icons.web,
        'title': 'Web Development',
        'subtitle': 'Modern web applications',
        'color': Colors.green,
      },
      {
        'icon': Icons.analytics,
        'title': 'Digital Marketing',
        'subtitle': 'SEO, SEM, Social Media',
        'color': Colors.orange,
      },
      {
        'icon': Icons.brush,
        'title': 'UI/UX Design',
        'subtitle': 'Creative design solutions',
        'color': Colors.pink,
      },
    ];

    return Column(
      children: services.map((service) {
        final color = service['color'] as Color;
        final colorWithOpacity20 = Color.fromRGBO(
          color.r.toInt(),
          color.g.toInt(),
          color.b.toInt(),
          0.2,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white10),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorWithOpacity20,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  service['icon'] as IconData,
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] as String,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['subtitle'] as String,
                      style: const TextStyle(
                        color: AppColors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.white50,
                size: 16,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepPurple,
        boxShadow: [
          BoxShadow(
            color: AppColors.black30,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 'Home', true),
              _buildNavItem(Icons.search, 'Search', false),
              _buildNavItem(Icons.favorite_outline, 'Favorites', false),
              _buildNavItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.gold20,
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: Icon(
            icon,
            color: isActive ? AppColors.primaryGold : AppColors.white50,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primaryGold : AppColors.white50,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
