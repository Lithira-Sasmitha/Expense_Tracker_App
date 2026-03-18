import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const AppText('Profile', fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 40),

            // Profile info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 60),
                  ),
                  const SizedBox(height: 15),
                  const AppText('Lithira Sasmitha', fontSize: 22, fontWeight: FontWeight.bold),
                  const AppText('lithira@example.com', fontSize: 14, color: AppColors.gray),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Settings sections
            _SectionTitle('Account'),
            _SettingTile(
              icon: Icons.person_outline_rounded,
              title: 'Personal Info',
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              onTap: () {},
            ),
            
            const SizedBox(height: 30),
            
            _SectionTitle('Preferences'),
            _SettingTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              isSwitch: true,
              switchValue: isDarkMode,
              onToggle: (value) {
                // TODO: Update theme preference
              },
            ),
             _SettingTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              isSwitch: true,
              switchValue: true,
              onToggle: (value) {},
            ),

            const SizedBox(height: 50),

            // Logout
            _SettingTile(
              icon: Icons.logout_rounded,
              title: 'Logout',
              color: Colors.redAccent,
              onTap: () {
                _onLogout(context);
              },
            ),
            
            const SizedBox(height: 20),
            const AppText('App Version 1.0.0', fontSize: 12, color: AppColors.gray),
          ],
        ),
      ),
    );
  }

  void _onLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              context.go(AppRouter.login);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 5),
        child: AppText(title, fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Function(bool)? onToggle;
  final bool isSwitch;
  final bool switchValue;
  final Color? color;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.onToggle,
    this.isSwitch = false,
    this.switchValue = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isDarkMode ? AppColors.surfaceDark : Colors.white,
      borderRadius: 15,
      child: ListTile(
        onTap: isSwitch ? null : onTap,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color ?? AppColors.primary, size: 22),
        ),
        title: AppText(title, fontWeight: FontWeight.w600, fontSize: 16),
        trailing: isSwitch 
            ? Switch(
                value: switchValue, 
                onChanged: onToggle,
                activeColor: AppColors.primary,
              )
            : const Icon(Icons.chevron_right_rounded, color: AppColors.gray),
      ),
    );
  }
}
