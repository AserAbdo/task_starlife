import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A custom styled text field with animations
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isFocused
                ? const [
                    BoxShadow(
                      color: AppColors.gold20,
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? AppColors.primaryGold
                          : AppColors.white70,
                    )
                  : null,
              suffixIcon: widget.suffixIcon,
            ),
          ),
        );
      },
    );
  }
}
