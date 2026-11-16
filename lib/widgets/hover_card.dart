import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final bool enableLift;
  final bool enableGlow;
  final Color? glowColor;

  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.hoverBorderColor,
    this.enableLift = true,
    this.enableGlow = true,
    this.glowColor,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveGlowColor = widget.glowColor ?? theme.primaryColor;
    final effectiveBg = widget.backgroundColor ?? theme.cardColor;
    final effectiveBorder = widget.borderColor ?? theme.dividerColor;
    final effectiveHoverBorder = widget.hoverBorderColor ?? theme.primaryColor.withValues(alpha: 0.6);

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(24),
          transform: widget.enableLift && _isHovered
              ? Matrix4.translationValues(0.0, -6.0, 0.0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _isHovered ? Color.alphaBlend(Colors.white.withValues(alpha: 0.03), effectiveBg) : effectiveBg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered ? effectiveHoverBorder : effectiveBorder,
              width: _isHovered ? 1.4 : 1.0,
            ),
            boxShadow: [
              if (_isHovered && widget.enableGlow)
                BoxShadow(
                  color: effectiveGlowColor.withValues(alpha: 0.22),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
