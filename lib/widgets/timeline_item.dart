import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'hover_card.dart';

class TimelineItem extends StatefulWidget {
  final Experience experience;
  final bool isLast;
  final PortfolioThemeData theme;

  const TimelineItem({
    super.key,
    required this.experience,
    this.isLast = false,
    required this.theme,
  });

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final exp = widget.experience;
    final t = widget.theme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line & indicator
            SizedBox(
              width: 36,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Glowing node indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: _isHovered ? 18 : 14,
                    height: _isHovered ? 18 : 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: exp.isCurrent
                          ? t.primaryGradient
                          : LinearGradient(
                              colors: [t.secondary, t.surfaceLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (exp.isCurrent ? t.primary : t.secondary)
                              .withValues(alpha: _isHovered ? 0.8 : 0.4),
                          blurRadius: _isHovered ? 14 : 8,
                          spreadRadius: _isHovered ? 2 : 0,
                        ),
                      ],
                    ),
                  ),
                  // Connecting line
                  if (!widget.isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              t.primary.withValues(alpha: 0.5),
                              t.border,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Content Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: HoverCard(
                  enableLift: true,
                  borderRadius: 16,
                  borderColor: _isHovered ? t.primaryLight.withValues(alpha: 0.5) : null,
                  glowColor: exp.isCurrent ? t.primary : t.secondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role & Company Header
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                exp.role,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: t.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: t.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: t.primary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  exp.company,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: t.primaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Date Period Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: exp.isCurrent ? t.primaryLight : t.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  exp.period,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: exp.isCurrent ? t.primaryLight : t.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        exp.description,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          color: t.textSecondary,
                        ),
                      ),

                      // Key Achievements
                      if (exp.keyAchievements.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        ...exp.keyAchievements.map(
                          (ach) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0, right: 8.0),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    size: 14,
                                    color: t.accent,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    ach,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      height: 1.45,
                                      color: t.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // Technologies tags
                      if (exp.technologies.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: exp.technologies.map((tech) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: t.surfaceLight,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: t.border),
                              ),
                              child: Text(
                                tech,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: t.textMuted,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
