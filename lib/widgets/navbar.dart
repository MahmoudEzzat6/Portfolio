import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'theme_switcher.dart';

class FloatingNavbar extends StatelessWidget {
  final List<String> navItems;
  final int activeIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onContactPressed;
  final VoidCallback? onMenuToggle;
  final PortfolioThemeData theme;
  final ThemePalette currentPalette;
  final ValueChanged<ThemePalette> onPaletteChanged;

  const FloatingNavbar({
    super.key,
    required this.navItems,
    required this.activeIndex,
    required this.onItemSelected,
    required this.onContactPressed,
    this.onMenuToggle,
    required this.theme,
    required this.currentPalette,
    required this.onPaletteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 860;
    final t = theme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1100),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: t.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo / Brand
                  // MouseRegion(
                  //   cursor: SystemMouseCursors.click,
                  //   child: GestureDetector(
                  //     onTap: () => onItemSelected(0),
                  //     child: Row(
                  //       children: [
                  //         Container(
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 10,
                  //             vertical: 6,
                  //           ),
                  //           decoration: BoxDecoration(
                  //             gradient: t.primaryGradient,
                  //             borderRadius: BorderRadius.circular(10),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: t.primary.withValues(alpha: 0.4),
                  //                 blurRadius: 10,
                  //               ),
                  //             ],
                  //           ),
                  //           child: const Text(
                  //             ' ',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.w900,
                  //               fontSize: 14,
                  //               color: Colors.white,
                  //               letterSpacing: 1.0,
                  //             ),
                  //           ),
                  //         ),

                  //         const SizedBox(width: 12),
                  //         RichText(
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: 'Mahmoud',
                  //                 style: TextStyle(
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: t.textPrimary,
                  //                 ),
                  //               ),
                  //               TextSpan(
                  //                 text: '.dev',
                  //                 style: TextStyle(
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.w600,
                  //                   color: t.accent,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // Desktop Nav Links & Theme Switcher
                  if (isDesktop) ...[
                    Row(
                      children: List.generate(navItems.length, (index) {
                        final isSelected = activeIndex == index;
                        return _NavButton(
                          title: navItems[index],
                          isSelected: isSelected,
                          theme: t,
                          onTap: () => onItemSelected(index),
                        );
                      }),
                    ),
                    Row(
                      children: [
                        ThemeSwitcher(
                          currentPalette: currentPalette,
                          onPaletteChanged: onPaletteChanged,
                        ),
                        const SizedBox(width: 14),
                        _NavCtaButton(onPressed: onContactPressed, theme: t),
                      ],
                    ),
                  ] else ...[
                    // Mobile controls
                    Row(
                      children: [
                        ThemeSwitcher(
                          currentPalette: currentPalette,
                          onPaletteChanged: onPaletteChanged,
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: onMenuToggle,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String title;
  final bool isSelected;
  final PortfolioThemeData theme;
  final VoidCallback onTap;

  const _NavButton({
    required this.title,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _isHovered;
    final t = widget.theme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: active ? t.textPrimary : t.textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isSelected ? 16 : (_isHovered ? 8 : 0),
                decoration: BoxDecoration(
                  gradient: t.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCtaButton extends StatefulWidget {
  final VoidCallback onPressed;
  final PortfolioThemeData theme;

  const _NavCtaButton({required this.onPressed, required this.theme});

  @override
  State<_NavCtaButton> createState() => _NavCtaButtonState();
}

class _NavCtaButtonState extends State<_NavCtaButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          transform: _isHovered
              ? Matrix4.diagonal3Values(1.05, 1.05, 1.0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            gradient: t.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: t.primary.withValues(alpha: _isHovered ? 0.5 : 0.25),
                blurRadius: _isHovered ? 16 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mail_outline_rounded, size: 14, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Let's Talk",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
