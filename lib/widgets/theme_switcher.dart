import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeSwitcher extends StatelessWidget {
  final ThemePalette currentPalette;
  final ValueChanged<ThemePalette> onPaletteChanged;

  const ThemeSwitcher({
    super.key,
    required this.currentPalette,
    required this.onPaletteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.palette_outlined, size: 15, color: Colors.white70),
          const SizedBox(width: 8),
          _PaletteDot(
            palette: ThemePalette.cyberIndigo,
            color: const Color(0xFF6366F1),
            tooltip: 'Cyber Indigo',
            isSelected: currentPalette == ThemePalette.cyberIndigo,
            onTap: () => onPaletteChanged(ThemePalette.cyberIndigo),
          ),
          const SizedBox(width: 6),
          _PaletteDot(
            palette: ThemePalette.emeraldMint,
            color: const Color(0xFF10B981),
            tooltip: 'Emerald Matrix',
            isSelected: currentPalette == ThemePalette.emeraldMint,
            onTap: () => onPaletteChanged(ThemePalette.emeraldMint),
          ),
          const SizedBox(width: 6),
          _PaletteDot(
            palette: ThemePalette.midnightCobalt,
            color: const Color(0xFF3B82F6),
            tooltip: 'Midnight Cobalt',
            isSelected: currentPalette == ThemePalette.midnightCobalt,
            onTap: () => onPaletteChanged(ThemePalette.midnightCobalt),
          ),
          const SizedBox(width: 6),
          _PaletteDot(
            palette: ThemePalette.crimsonRose,
            color: const Color(0xFFF43F5E),
            tooltip: 'Crimson Titanium',
            isSelected: currentPalette == ThemePalette.crimsonRose,
            onTap: () => onPaletteChanged(ThemePalette.crimsonRose),
          ),
        ],
      ),
    );
  }
}

class _PaletteDot extends StatefulWidget {
  final ThemePalette palette;
  final Color color;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaletteDot({
    required this.palette,
    required this.color,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PaletteDot> createState() => _PaletteDotState();
}

class _PaletteDotState extends State<_PaletteDot> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.isSelected ? 22 : (_isHovered ? 20 : 16),
            height: widget.isSelected ? 22 : (_isHovered ? 20 : 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              border: Border.all(
                color: widget.isSelected ? Colors.white : Colors.transparent,
                width: widget.isSelected ? 2.5 : 1.0,
              ),
              boxShadow: [
                if (widget.isSelected || _isHovered)
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.8),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
