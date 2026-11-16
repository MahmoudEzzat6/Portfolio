import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileAvatarSection extends StatefulWidget {
  final PortfolioThemeData theme;
  final String imageUrl;
  final ValueChanged<String>? onImageChanged;

  const ProfileAvatarSection({
    super.key,
    required this.theme,
    required this.imageUrl,
    this.onImageChanged,
  });

  @override
  State<ProfileAvatarSection> createState() => _ProfileAvatarSectionState();
}

class _ProfileAvatarSectionState extends State<ProfileAvatarSection>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _floatController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _showEditImageDialog(BuildContext context) {
    final controller = TextEditingController(text: widget.imageUrl);

    showDialog(
      context: context,
      builder: (ctx) {
        final t = widget.theme;
        return AlertDialog(
          backgroundColor: t.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: t.borderGlow),
          ),
          title: Row(
            children: [
              Icon(Icons.link_rounded, color: t.primaryLight, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Change Profile Image Link',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter a global online URL (e.g. from GitHub, Google Drive, Imgur, Cloudinary, or web):',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'https://example.com/my-photo.jpg',
                  hintStyle: const TextStyle(
                    color: Colors.white30,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: t.surfaceLight,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: t.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: t.primaryLight),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text(
                      'GitHub Avatar',
                      style: TextStyle(fontSize: 11),
                    ),
                    backgroundColor: t.surfaceLight,
                    onPressed: () {
                      controller.text = 'https://avatars.githubusercontent.com/u/108343715?v=4';
                    },
                  ),
                  ActionChip(
                    label: const Text(
                      'Developer Portrait',
                      style: TextStyle(fontSize: 11),
                    ),
                    backgroundColor: t.surfaceLight,
                    onPressed: () {
                      controller.text = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80';
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newUrl = controller.text.trim();
                if (newUrl.isNotEmpty && widget.onImageChanged != null) {
                  widget.onImageChanged!(newUrl);
                }
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Update Global Link',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _floatController]),
        builder: (context, child) {
          final floatOffset =
              math.sin(_floatController.value * 2 * math.pi) * 8;

          return SizedBox(
            width: 380,
            height: 420,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Ambient Radial Glow behind avatar
                Positioned(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isHovered ? 330 : 290,
                    height: _isHovered ? 330 : 290,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          t.primary.withValues(alpha: _isHovered ? 0.45 : 0.25),
                          t.secondary.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Rotating Gradient Ring
                Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: Container(
                    width: 290,
                    height: 290,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      gradient: SweepGradient(
                        colors: [t.primary, t.secondary, t.accent, t.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: t.primary.withValues(
                            alpha: _isHovered ? 0.6 : 0.3,
                          ),
                          blurRadius: _isHovered ? 32 : 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: t.background,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),

                // Main Avatar Box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 272,
                  height: 272,
                  transform: Matrix4.translationValues(
                    0,
                    -floatOffset * 0.4,
                    0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: t.surfaceLight,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        // Smart Image: Supports global online URL and local asset
                        Positioned.fill(child: _buildImage(widget.imageUrl, t)),

                        // Subtle bottom gradient vignette
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  t.surface.withValues(alpha: 0.85),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),

                        // Top-right Change Link button on hover or click
                        // Positioned(
                        //   top: 10,
                        //   right: 10,
                        //   child: Material(
                        //     color: Colors.black.withValues(alpha: 0.6),
                        //     borderRadius: BorderRadius.circular(20),
                        //     child: InkWell(
                        //       borderRadius: BorderRadius.circular(20),
                        //       onTap: () => _showEditImageDialog(context),
                        //       child: Tooltip(
                        //         message: 'Change Global Image Link',
                        //         child: Padding(
                        //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        //           child: Row(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               Icon(Icons.edit_rounded, size: 12, color: t.primaryLight),
                        //               const SizedBox(width: 4),
                        //               const Text(
                        //                 'Link',
                        //                 style: TextStyle(
                        //                   fontSize: 10,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: Colors.white,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // Bottom Developer Status Pill
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: t.background.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: t.primary.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: t.accent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Flexible(
                                  child: Text(
                                    'Mahmoud Ezzat • Flutter Dev',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Badge 1: Flutter & Dart (Top Right)
                Positioned(
                  top: 20 + floatOffset,
                  right: -10,
                  child: _FloatingBadge(
                    icon: Icons.flutter_dash_rounded,
                    label: 'Flutter & Dart',
                    sub: 'iOS • Android • Desktop',
                    accentColor: t.primary,
                    theme: t,
                  ),
                ),

                // Floating Badge 2: Clean Architecture (Bottom Left)
                Positioned(
                  bottom: 25 - floatOffset,
                  left: -15,
                  child: _FloatingBadge(
                    icon: Icons.verified_rounded,
                    label: 'Clean Architecture',
                    sub: 'BLoC • State Expert',
                    accentColor: t.accent,
                    theme: t,
                  ),
                ),

                // Floating Badge 3: 2+ Years Exp (Top Left)
                Positioned(
                  top: 50 - floatOffset * 0.7,
                  left: -12,
                  child: _MiniFloatingBadge(text: '⚡ 2+ Yrs Exp', theme: t),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(String path, PortfolioThemeData t) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: t.primaryLight,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar(t);
        },
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/profile.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error2, stackTrace2) {
              return Image.asset(
                'assets/images/profile_image.jfif',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error3, stackTrace3) {
                  return _buildFallbackAvatar(t);
                },
              );
            },
          );
        },
      );
    }
  }

  Widget _buildFallbackAvatar(PortfolioThemeData t) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [t.surfaceLight, t.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: t.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: t.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '<ME />',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: t.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap "Link" to set photo URL',
              style: TextStyle(fontSize: 10, color: t.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color accentColor;
  final PortfolioThemeData theme;

  const _FloatingBadge({
    required this.icon,
    required this.label,
    required this.sub,
    required this.accentColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(color: accentColor.withValues(alpha: 0.2), blurRadius: 12),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: theme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniFloatingBadge extends StatelessWidget {
  final String text;
  final PortfolioThemeData theme;

  const _MiniFloatingBadge({required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
