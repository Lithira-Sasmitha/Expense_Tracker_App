import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.backgroundDark 
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const AppText('Personal Information', fontSize: 20, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 70,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppText(user.name ?? 'Guest User', fontSize: 22, fontWeight: FontWeight.bold),
                  AppText('Manage your personal details', fontSize: 14, color: AppColors.gray),
                  
                  const SizedBox(height: 40),
                  
                  _DetailTile(
                    label: 'Full Name',
                    value: user.name ?? 'Not Set',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 16),
                  
                  _DetailTile(
                    label: 'Email Address',
                    value: user.email,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  
                  _DetailTile(
                    label: 'User ID',
                    value: user.id,
                    icon: Icons.fingerprint_rounded,
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Optional Action Button (e.g., Edit Profile)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRouter.editProfile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const AppText('Edit Profile', color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      color: isDarkMode ? AppColors.surfaceDark : Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(label, color: AppColors.gray, fontSize: 13, fontWeight: FontWeight.w500),
                const SizedBox(height: 4),
                AppText(value, fontSize: 16, fontWeight: FontWeight.bold, maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
