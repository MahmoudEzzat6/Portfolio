import 'package:flutter/material.dart';

class InteractiveSkillChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color? accentColor;

  const InteractiveSkillChip({
    super.key,
    required this.label,
    this.icon,
    this.accentColor,
  });

  @override
  State<InteractiveSkillChip> createState() => _InteractiveSkillChipState();
}

class _InteractiveSkillChipState extends State<InteractiveSkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = widget.accentColor ?? theme.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuad,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        transform: _isHovered
            ? Matrix4.translationValues(0.0, -3.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: _isHovered
              ? accent.withValues(alpha: 0.15)
              : theme.cardColor.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered
                ? accent.withValues(alpha: 0.6)
                : theme.dividerColor.withValues(alpha: 0.8),
            width: _isHovered ? 1.4 : 1.0,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: accent.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: 16,
                color: _isHovered ? accent : Colors.white70,
              ),
              const SizedBox(width: 8),
            ] else ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isHovered ? accent : accent.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                color: _isHovered ? Colors.white : Colors.white70,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
