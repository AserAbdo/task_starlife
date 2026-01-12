import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A custom animated button with gradient and loading state
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width ?? double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? AppColors.goldGradient
                    : const LinearGradient(
                        colors: [AppColors.grey50, AppColors.grey30],
                      ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isEnabled
                    ? const [
                        BoxShadow(
                          color: AppColors.gold40,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.deepPurple,
                          ),
                        ),
                      )
                    : Text(
                        widget.text,
                        style: const TextStyle(
                          color: AppColors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
