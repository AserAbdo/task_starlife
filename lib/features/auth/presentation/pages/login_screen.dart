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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.gold30, width: 1),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 12),
            Text(
              'Success!',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'You have successfully logged in to Star Life!',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text(
              'Continue',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
            _showSuccessDialog(context);
          } else if (state is LoginError) {
            _showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return Scaffold(
            body: GradientBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),

                              // Logo
                              _buildLogo(),

                              const SizedBox(height: 24),

                              // Welcome text
                              _buildWelcomeText(),

                              const SizedBox(height: 48),

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

                              const SizedBox(height: 20),

                              // Password field
                              CustomTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Enter your password',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                validator: Validators.validatePassword,
                                onFieldSubmitted: (_) => _onLogin(context),
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

                              const SizedBox(height: 12),

                              // Forgot password
                              _buildForgotPassword(),

                              const SizedBox(height: 32),

                              // Login button
                              CustomButton(
                                text: 'Login',
                                isLoading: isLoading,
                                onPressed: () => _onLogin(context),
                              ),

                              const SizedBox(height: 24),

                              // Divider
                              _buildDivider(),

                              const SizedBox(height: 24),

                              // Social login buttons
                              _buildSocialLogin(),

                              const SizedBox(height: 32),

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
        width: 140,
        height: 140,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: AppColors.gold30, blurRadius: 30, spreadRadius: 5),
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
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sign in to continue to Star Life',
          style: TextStyle(fontSize: 16, color: AppColors.white70),
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
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w500,
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
        _buildSocialButton(Icons.g_mobiledata_rounded, 'Google'),
        const SizedBox(width: 16),
        _buildSocialButton(Icons.apple, 'Apple'),
        const SizedBox(width: 16),
        _buildSocialButton(Icons.facebook, 'Facebook'),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white20),
      ),
      child: IconButton(
        onPressed: () {
          // TODO: Implement social login
        },
        icon: Icon(icon, color: AppColors.white, size: 28),
        tooltip: label,
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppColors.white70),
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
            ),
          ),
        ),
      ],
    );
  }
}
