import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'hover_card.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final Function(String) onLaunchUrl;
  final PortfolioThemeData theme;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onLaunchUrl,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme;

    return HoverCard(
      borderRadius: 18,
      padding: EdgeInsets.zero,
      enableLift: true,
      enableGlow: true,
      glowColor: t.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent gradient banner
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: project.gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Icon badge & Tag pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: project.gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: t.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: project.projectImageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                project.projectImageUrl!,
                                height: 26,
                                width: 26,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    project.icon,
                                    color: Colors.white,
                                    size: 24,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              project.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        project.tag,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: t.accent,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Title
                Text(
                  project.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: t.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: t.textSecondary,
                  ),
                ),

                // Highlights
                if (project.highlights.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  ...project.highlights.map(
                    (h) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 3.0,
                              right: 8.0,
                            ),
                            child: Icon(
                              Icons.arrow_right_alt_rounded,
                              size: 16,
                              color: t.primaryLight,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              h,
                              style: TextStyle(
                                fontSize: 13,
                                color: t.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Technology Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.map((tech) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: t.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: t.border),
                      ),
                      child: Text(
                        tech,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: t.textMuted,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                Divider(color: t.border, height: 1),
                const SizedBox(height: 14),

                // Action Buttons
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (project.playStoreUrl != null)
                      _CardActionButton(
                        icon: Icons.shop_two_rounded,
                        label: 'Google Play',
                        onTap: () => onLaunchUrl(project.playStoreUrl!),
                        isPrimary: true,
                        theme: t,
                      ),
                    if (project.appStoreUrl != null)
                      _CardActionButton(
                        icon: Icons.apple_rounded,
                        label: 'App Store',
                        onTap: () => onLaunchUrl(project.appStoreUrl!),
                        isPrimary: project.playStoreUrl == null,
                        theme: t,
                      ),
                    if (project.liveUrl != null)
                      _CardActionButton(
                        icon: Icons.launch_rounded,
                        label: 'View Project',
                        onTap: () => onLaunchUrl(project.liveUrl!),
                        isPrimary: project.playStoreUrl == null && project.appStoreUrl == null,
                        theme: t,
                      ),
                    if (project.githubUrl != null)
                      _CardActionButton(
                        icon: Icons.code_rounded,
                        label: 'Code / Info',
                        onTap: () => onLaunchUrl(project.githubUrl!),
                        isPrimary: false,
                        theme: t,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final PortfolioThemeData theme;

  const _CardActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isPrimary,
    required this.theme,
  });

  @override
  State<_CardActionButton> createState() => _CardActionButtonState();
}

class _CardActionButtonState extends State<_CardActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered ? t.primary : t.primary.withValues(alpha: 0.15))
                : (_isHovered
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.04)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isPrimary
                  ? (_isHovered ? t.primary : t.primary.withValues(alpha: 0.4))
                  : (_isHovered ? Colors.white30 : Colors.white10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: widget.isPrimary
                    ? (_isHovered ? Colors.white : t.primaryLight)
                    : Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: widget.isPrimary
                      ? (_isHovered ? Colors.white : t.primaryLight)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
