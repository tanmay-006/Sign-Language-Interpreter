// filepath: e:\Hackathon\Sign_language_Bhumi\Sign_language_2\lib\src\utils\widgets\common_widgets.dart
import 'package:flutter/material.dart';
import 'package:sign_language_2/src/utils/utils/theme/theme.dart';
import 'dart:ui';

class CommonWidgets {
  // Glassmorphic Container
  static Widget glassmorphicContainer({
    required Widget child,
    required double width,
    required double height,
    double borderRadius = 16,
    double blur = 10,
    Color borderColor = Colors.white30,
    Color backgroundColor = Colors.white12,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }

  // Primary Button
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double width = double.infinity,
    double height = 55,
    double borderRadius = 16,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(text),
      ),
    );
  }

  // Outline Button
  static Widget outlineButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double width = double.infinity,
    double height = 55,
    double borderRadius = 16,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: AppTheme.primaryColor)
            : Text(
                text,
                style: const TextStyle(color: AppTheme.primaryColor),
              ),
      ),
    );
  }

  // Custom TextField
  static Widget customTextField({
    required String label,
    String? hint,
    TextEditingController? controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  // Section Title
  static Widget sectionTitle(String title, {bool isPrimary = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isPrimary ? AppTheme.primaryColor : AppTheme.textPrimary,
        ),
      ),
    );
  }

  // Card Container
  static Widget cardContainer({
    required Widget child,
    double elevation = 2,
    double borderRadius = 16,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Color? backgroundColor,
  }) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }

  // Gradient Background
  static Widget gradientBackground({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: child,
    );
  }

  // Loading Indicator
  static Widget loadingIndicator({Color? color}) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppTheme.primaryColor,
      ),
    );
  }

  // Error Message
  static Widget errorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.errorColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  // Divider with Text
  static Widget dividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  // Professional Avatar Widget
  static Widget circleAvatar({
    String? imageUrl,
    double radius = 40,
    String? fallbackInitials,
    Color backgroundColor = AppTheme.primaryColor,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
      child: imageUrl == null
          ? Text(
              fallbackInitials ?? "U",
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.7,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  // Feature Card with Icon
  static Widget featureCard({
    required String title,
    required String description,
    required IconData icon,
    VoidCallback? onTap,
    Color iconColor = AppTheme.primaryColor,
    double height = 180,
  }) {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: iconColor),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom App Bar
  static PreferredSizeWidget customAppBar({
    required String title,
    List<Widget>? actions,
    bool centerTitle = true,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    double elevation = 0,
    Color? backgroundColor,
  }) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onBackPressed ??
                  () => Navigator.of(_materialNavigatorContext()).pop(),
            )
          : null,
      actions: actions,
    );
  }

  // Helper method to get navigator context
  static BuildContext _materialNavigatorContext() {
    return Navigator.of(
      WidgetsBinding.instance.rootElement!.buildScope(),
      rootNavigator: true,
    ).context;
  }

  // Empty State Widget
  static Widget emptyStateWidget({
    required String message,
    IconData icon = Icons.hourglass_empty,
    double iconSize = 80,
    VoidCallback? onActionPressed,
    String actionText = "Try Again",
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onActionPressed,
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Badge Widget
  static Widget badge({
    required String text,
    Color backgroundColor = AppTheme.primaryColor,
    Color textColor = Colors.white,
    double borderRadius = 16,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Animated Button
  static Widget animatedButton({
    required String text,
    required VoidCallback onPressed,
    double width = double.infinity,
    double height = 55,
    Color color = AppTheme.primaryColor,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) {
            setState(() => isPressed = false);
            onPressed();
          },
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
              transform: isPressed
                  ? Matrix4.translationValues(0, 2, 0)
                  : Matrix4.translationValues(0, 0, 0),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Custom SnackBar
  static void showSnackBar(
    BuildContext context, {
    required String message,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 4),
    Color backgroundColor = AppTheme.primaryColor,
    bool showCloseIcon = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: behavior,
        duration: duration,
        backgroundColor: backgroundColor,
        action: showCloseIcon
            ? SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Toggle Switch
  static Widget toggleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    String? label,
    Color activeColor = AppTheme.primaryColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          activeTrackColor: activeColor.withOpacity(0.4),
        ),
      ],
    );
  }

  // Rating Stars
  static Widget ratingStars({
    required double rating,
    int totalStars = 5,
    double size = 24,
    Color color = Colors.amber,
    Color borderColor = Colors.grey,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index < rating ? Icons.star_half : Icons.star_border),
          color: index < rating ? color : borderColor,
          size: size,
        );
      }),
    );
  }

  // Shimmer Loading Effect
  static Widget shimmerLoading({
    required Widget child,
    Color baseColor = Colors.grey,
    Color highlightColor = Colors.white,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                baseColor.withOpacity(0.2),
                highlightColor.withOpacity(0.5),
                baseColor.withOpacity(0.2)
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: const Alignment(-1.0, -0.5),
              end: const Alignment(1.0, 0.5),
            ),
          ),
          child: child,
        );
      },
    );
  }

  // Step Indicator
  static Widget stepIndicator({
    required int currentStep,
    required int totalSteps,
    Color activeColor = AppTheme.primaryColor,
    Color inactiveColor = Colors.grey,
    double size = 12,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentStep ? size * 2 : size,
          height: size,
          decoration: BoxDecoration(
            color: index <= currentStep
                ? activeColor
                : inactiveColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
      ),
    );
  }
}
