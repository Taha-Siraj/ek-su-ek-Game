import 'package:flutter/material.dart';
import '../theme.dart';

enum NeonButtonType { primary, secondary, tertiary }

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final NeonButtonType type;
  final IconData? icon;
  final bool fullWidth;

  const NeonButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.type = NeonButtonType.primary,
    this.icon,
    this.fullWidth = true,
  }) : super(key: key);

  const NeonButton.primary({
    Key? key,
    required this.text,
    required this.onTap,
    this.icon,
    this.fullWidth = true,
  })  : type = NeonButtonType.primary,
        super(key: key);

  const NeonButton.secondary({
    Key? key,
    required this.text,
    required this.onTap,
    this.icon,
    this.fullWidth = true,
  })  : type = NeonButtonType.secondary,
        super(key: key);

  const NeonButton.tertiary({
    Key? key,
    required this.text,
    required this.onTap,
    this.icon,
    this.fullWidth = true,
  })  : type = NeonButtonType.tertiary,
        super(key: key);

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              color: _getTextColor(),
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            widget.text,
            style: MidnightNeonTheme.buttonText.copyWith(
              color: _getTextColor(),
            ),
          ),
        ],
      ),
    );

    BoxDecoration decoration;

    switch (widget.type) {
      case NeonButtonType.primary:
        decoration = BoxDecoration(
          color: MidnightNeonTheme.primaryContainer,
          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
          boxShadow: [
            BoxShadow(color: Colors.transparent, blurRadius: 0),
          ],
        );
        break;
      case NeonButtonType.secondary:
        decoration = BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
          border: Border.all(
            color: MidnightNeonTheme.primaryContainer,
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(color: Colors.transparent, blurRadius: 0),
                ]
              : null,
        );
        break;
      case NeonButtonType.tertiary:
        decoration = BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(MidnightNeonTheme.radiusMedium),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        );
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            widget.onTap();
          },
          onTapCancel: () => _controller.reverse(),
          child: Container(
            width: widget.fullWidth ? double.infinity : null,
            decoration: decoration,
            child: buttonContent,
          ),
        ),
      ),
    );
  }

  Color _getTextColor() {
    switch (widget.type) {
      case NeonButtonType.primary:
        return MidnightNeonTheme.bgPrimary;
      case NeonButtonType.secondary:
        return MidnightNeonTheme.primaryContainer;
      case NeonButtonType.tertiary:
        return Colors.white;
    }
  }
}
