import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../../../home/presentation/pages/home_screen.dart';

/// Login screen with email and password fields
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // Pre-filled with test credentials for easy testing
  final _emailController = TextEditingController(text: 'test@starlife.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Login successful! Welcome to Star Life',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            _showSuccessSnackBar(context);
            // Store navigator and email before async gap
            final navigator = Navigator.of(context);
            final userEmail = state.user.email;
            // Navigate to home after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                navigator.pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        HomeScreen(email: userEmail),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                              child: child,
                            ),
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              }
            });
          } else if (state is LoginError) {
            _showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return Scaffold(
            body: GradientBackground(
              child: SafeArea(
                top: false,
                bottom: false,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 32),

                                    // Logo - smaller
                                    _buildLogo(),

                                    const SizedBox(height: 16),

                                    // Welcome text
                                    _buildWelcomeText(),

                                    const SizedBox(height: 28),

                                    // Email field
                                    CustomTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      hint: 'Enter your email',
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      validator: Validators.validateEmail,
                                    ),

                                    const SizedBox(height: 14),

                                    // Password field
                                    CustomTextField(
                                      controller: _passwordController,
                                      label: 'Password',
                                      hint: 'Enter your password',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      validator: Validators.validatePassword,
                                      onFieldSubmitted: (_) =>
                                          _onLogin(context),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: AppColors.white70,
                                        ),
                                        onPressed: _togglePasswordVisibility,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    // Forgot password
                                    _buildForgotPassword(),

                                    const SizedBox(height: 20),

                                    // Login button
                                    CustomButton(
                                      text: 'Login',
                                      isLoading: isLoading,
                                      onPressed: () => _onLogin(context),
                                    ),

                                    const SizedBox(height: 20),

                                    // Divider
                                    _buildDivider(),

                                    const SizedBox(height: 20),

                                    // Social login buttons - just 3 icons
                                    _buildSocialLogin(),

                                    const SizedBox(height: 20),

                                    // Sign up link
                                    _buildSignUpLink(),

                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'logo',
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: AppColors.gold30, blurRadius: 25, spreadRadius: 3),
          ],
        ),
        child: ClipOval(
          child: Image.asset('assets/logo.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Column(
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Sign in to continue to Star Life',
          style: TextStyle(fontSize: 14, color: AppColors.white70),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, AppColors.white30],
              ),
            ),
            child: SizedBox(height: 1),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: AppColors.white50,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.white30, Colors.transparent],
              ),
            ),
            child: SizedBox(height: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _buildSocialIcon(
          imagePath: 'assets/google.png',
          onTap: () {
            // TODO: Implement Google login
          },
        ),
        const SizedBox(width: 20),
        // Apple
        _buildSocialIcon(
          icon: Icons.apple,
          onTap: () {
            // TODO: Implement Apple login
          },
        ),
        const SizedBox(width: 20),
        // Facebook
        _buildSocialIcon(
          icon: Icons.facebook,
          iconColor: const Color(0xFF1877F2),
          onTap: () {
            // TODO: Implement Facebook login
          },
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    String? imagePath,
    IconData? icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.white20),
          ),
          child: Center(
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      imagePath,
                      width: 26,
                      height: 26,
                      fit: BoxFit.contain,
                    ),
                  )
                : Icon(icon, color: iconColor ?? AppColors.white, size: 26),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppColors.white70, fontSize: 13),
        ),
        TextButton(
          onPressed: () {
            // TODO: Navigate to sign up
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
