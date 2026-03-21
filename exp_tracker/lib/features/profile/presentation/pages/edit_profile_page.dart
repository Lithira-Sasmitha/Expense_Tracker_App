import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    String initialName = '';
    if (authState is Authenticated) {
      initialName = authState.user.name ?? '';
    }
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(UpdateProfileEvent(name: _nameController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          context.pop();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: AppScaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.backgroundDark 
            : AppColors.backgroundLight,
        appBar: AppBar(
          title: const AppText('Edit Profile', fontSize: 20, fontWeight: FontWeight.bold),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.primary),
            onPressed: () => context.pop(),
          ),
          actions: [
            TextButton(
              onPressed: _onSave,
              child: const AppText('Save', color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Image placeholder
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 80,
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        
                        // Name field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText('Full Name', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark 
                                    ? AppColors.surfaceDark 
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Name cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        const AppText(
                          'Note: You can only edit your name for now. Email change requires additional verification.',
                          fontSize: 12,
                          color: AppColors.gray,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
