import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/portfolio_config.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/animated_fade_slide.dart';
import '../widgets/hover_card.dart';
import '../widgets/navbar.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/project_card.dart';
import '../widgets/pulsing_badge.dart';
import '../widgets/skill_chip.dart';
import '../widgets/theme_switcher.dart';
import '../widgets/timeline_item.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();

  // Section Keys for smooth scrolling
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  int _activeNavIndex = 0;
  bool _showBackToTop = false;

  // Dynamic Theme state
  ThemePalette _currentPalette = ThemePalette.cyberIndigo;

  // Global Profile Image URL (Global web link)
  String _profileImageUrl = PortfolioConfig.defaultProfileImageUrl;

  // Selected skill category filter
  int _selectedSkillCategory = 0;

  final List<String> _navSections = [
    'About',
    'Skills',
    'Experience',
    'Projects',
    'Contact',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 350 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 350 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }
  }

  void _scrollToSection(int index) {
    setState(() => _activeNavIndex = index);
    final keys = [
      _heroKey,
      _skillsKey,
      _experienceKey,
      _projectsKey,
      _contactKey,
    ];

    if (index >= 0 && index < keys.length) {
      final context = keys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  // Opens Gmail directly in browser or fallback to mailto
  Future<void> _openGmail() async {
    const gmailUrl =
        'https://mail.google.com/mail/?view=cm&fs=1&to=ezzatmahmoud08@gmail.com&su=Project%20Opportunity%20-%20Mahmoud%20Ezzat';
    final uri = Uri.parse(gmailUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(
        Uri.parse('mailto:ezzatmahmoud08@gmail.com'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.getTheme(_currentPalette);

    return Theme(
      data: AppThemes.buildTheme(theme),
      child: Scaffold(
        backgroundColor: theme.background,
        endDrawer: _buildMobileDrawer(theme),
        body: AmbientBackground(
          theme: theme,
          child: Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 90), // Space for floating navbar
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1060),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroSection(theme),
                            const SizedBox(height: 70),
                            _buildStatsSection(theme),
                            const SizedBox(height: 80),
                            _buildSkillsSection(theme),
                            const SizedBox(height: 80),
                            _buildExperienceSection(theme),
                            const SizedBox(height: 80),
                            _buildFeaturedProjects(theme),
                            const SizedBox(height: 80),
                            _buildContactSection(theme),
                            const SizedBox(height: 60),
                            _buildFooter(theme),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Top sticky glassmorphism navbar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FloatingNavbar(
                  navItems: _navSections,
                  activeIndex: _activeNavIndex,
                  theme: theme,
                  currentPalette: _currentPalette,
                  onPaletteChanged: (p) => setState(() => _currentPalette = p),
                  onItemSelected: _scrollToSection,
                  onContactPressed: _openGmail,
                  onMenuToggle: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),

              // Floating back-to-top button
              if (_showBackToTop)
                Positioned(
                  bottom: 28,
                  right: 28,
                  child: _buildBackToTopButton(theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(PortfolioThemeData theme) {
    return Drawer(
      backgroundColor: theme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 10,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     gradient: theme.primaryGradient,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: const Text(
                  //     ' ',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.w900,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),

                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Theme switcher inside drawer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Theme Palette:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  ThemeSwitcher(
                    currentPalette: _currentPalette,
                    onPaletteChanged: (p) =>
                        setState(() => _currentPalette = p),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white12),
              const SizedBox(height: 12),
              ...List.generate(_navSections.length, (index) {
                return ListTile(
                  title: Text(
                    _navSections[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: theme.textMuted,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _scrollToSection(index);
                  },
                );
              }),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openGmail();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Open Gmail / Contact",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HERO SECTION with Image Showcase
  Widget _buildHeroSection(PortfolioThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 840;

        final textContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Availability badge
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 100),
              child: PulsingBadge(
                text: 'Available for New Projects & Roles',
                dotColor: theme.primaryLight,
              ),
            ),
            const SizedBox(height: 20),

            // Name with glowing gradient accent
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 200),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'MAHMOUD ',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                      color: theme.textPrimary,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        theme.primaryGradient.createShader(bounds),
                    child: Text(
                      'EZZAT',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Role subtitle
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 300),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: theme.primaryGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mid-Level Flutter Developer | Mobile & Desktop Engineer',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryLight,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bio
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 400),
              child: Text(
                'Results-driven Software Engineer with 2+ years of hands-on experience designing, architecting, and launching high-performance cross-platform applications. Specialist in Clean Architecture, reactive state management (BLoC, Cubit, GetX), commercial POS engines, and third-party payment gateways.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.65,
                  color: theme.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons & Socials
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 500),
              child: Wrap(
                spacing: 14,
                runSpacing: 14,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _GradientButton(
                    icon: Icons.mail_rounded,
                    label: 'Send Email via Gmail',
                    theme: theme,
                    onPressed: _openGmail,
                  ),
                  _OutlinedIconButton(
                    icon: Icons.explore_rounded,
                    label: 'View Projects',
                    theme: theme,
                    onPressed: () => _scrollToSection(3),
                  ),
                  const SizedBox(width: 6),
                  _SocialIconButton(
                    icon: Icons.chat_rounded,
                    tooltip: 'WhatsApp (+20 112 931 16102)',
                    theme: theme,
                    onTap: () => _launchUrl('https://wa.me/201129316102'),
                  ),
                  _SocialIconButton(
                    icon: Icons.business_center_rounded,
                    tooltip: 'LinkedIn',
                    theme: theme,

                    onTap: () => _launchUrl(
                      'https://www.linkedin.com/in/mahmoud-ezzat-174b41165',
                    ),
                  ),
                  _SocialIconButton(
                    icon: Icons.code_rounded,
                    tooltip: 'GitHub Profile',
                    theme: theme,
                    onTap: () => _launchUrl('https://github.com/MahmoudEzzat6'),
                  ),
                ],
              ),
            ),
          ],
        );

        if (isDesktop) {
          return Container(
            key: _heroKey,
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: textContent),
                const SizedBox(width: 40),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: ProfileAvatarSection(
                      theme: theme,
                      imageUrl: _profileImageUrl,
                      onImageChanged: (newUrl) => setState(() => _profileImageUrl = newUrl),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            key: _heroKey,
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Center(
                  child: ProfileAvatarSection(
                    theme: theme,
                    imageUrl: _profileImageUrl,
                    onImageChanged: (newUrl) => setState(() => _profileImageUrl = newUrl),
                  ),
                ),
                const SizedBox(height: 36),
                textContent,
              ],
            ),
          );
        }
      },
    );
  }

  // IMPACT STATS SECTION (Generous height, 0 overflow risk)
  Widget _buildStatsSection(PortfolioThemeData theme) {
    final stats = [
      {
        'number': '2+',
        'label': 'Years Experience',
        'sub': 'Production Flutter',
      },
      {'number': '10+', 'label': 'Apps Delivered', 'sub': 'Mobile & Desktop'},
      {
        'number': '100%',
        'label': 'Clean Architecture',
        'sub': 'Scalable & Testable',
      },
      {
        'number': '3',
        'label': 'Platforms Supported',
        'sub': 'iOS, Android & Desktop',
      },
    ];

    return AnimatedFadeSlide(
      delay: const Duration(milliseconds: 200),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 650;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmall ? 2 : 4,
              mainAxisExtent:
                  130, // Generous height to prevent any text overflow
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final item = stats[index];
              return HoverCard(
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                glowColor: theme.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          theme.primaryGradient.createShader(bounds),
                      child: Text(
                        item['number']!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['sub']!,
                      style: TextStyle(fontSize: 11, color: theme.textMuted),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // TECHNICAL SKILLS SECTION
  Widget _buildSkillsSection(PortfolioThemeData theme) {
    final categories = [
      const SkillCategory(
        name: 'All Skills',
        icon: Icons.apps_rounded,
        skills: [
          'Flutter (iOS & Android)',
          'Flutter Desktop (Windows/macOS)',
          'Dart Language',
          'Clean Architecture',
          'BLoC / Cubit Pattern',
          'Provider',
          'GetX',
          'RESTful APIs & Dio',
          'Firebase & Push Notifications',
          'Fawry & QNB Payment Gateways',
          'Google Maps Integration',
          'Offline Sync (Hive & SQLite)',
          'Thermal Receipt Printing (ESC/POS)',
          'Git & GitHub Actions',
          'SOLID & Design Patterns',
        ],
      ),
      const SkillCategory(
        name: 'Core & Platforms',
        icon: Icons.phone_iphone_rounded,
        skills: [
          'Flutter (iOS & Android)',
          'Flutter Desktop (Windows/macOS)',
          'Dart Language',
          'Responsive UI/UX',
          'Material 3 & Cupertino',
          'Custom Animations & Painters',
        ],
      ),
      const SkillCategory(
        name: 'Architecture & State',
        icon: Icons.account_tree_rounded,
        skills: [
          'Clean Architecture',
          'BLoC / Cubit Pattern',
          'Provider',
          'GetX',
          'SOLID Principles',
          'Dependency Injection (get_it)',
        ],
      ),
      const SkillCategory(
        name: 'APIs & Backend',
        icon: Icons.cloud_done_rounded,
        skills: [
          'RESTful APIs & Dio',
          'Firebase Authentication',
          'Cloud Firestore',
          'Push Notifications (FCM)',
          'Local Storage (Hive, SQLite)',
          'WebSocket Realtime Sync',
        ],
      ),
      const SkillCategory(
        name: 'Hardware & Integrations',
        icon: Icons.credit_card_rounded,
        skills: [
          'Fawry Payment Gateway',
          'QNB Payment Gateway',
          'Google Maps API',
          'Thermal POS Printers (ESC/POS)',
          'Barcode & QR Code Scanning',
        ],
      ),
    ];

    final currentCategory = categories[_selectedSkillCategory];

    return Container(
      key: _skillsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            theme: theme,
            badge: 'TECH STACK',
            title: 'Technical Skills & Expertise',
            subtitle: 'Modern cross-platform development toolkit built for scalability, speed, and elegance.',
          ),
          const SizedBox(height: 24),

          // Filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                final cat = categories[index];
                final isSelected = _selectedSkillCategory == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: Icon(
                      cat.icon,
                      size: 16,
                      color: isSelected ? Colors.white : theme.textSecondary,
                    ),
                    label: Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : theme.textSecondary,
                      ),
                    ),
                    backgroundColor: theme.surface,
                    selectedColor: theme.primary,
                    side: BorderSide(
                      color: isSelected ? theme.primaryLight : theme.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (_) =>
                        setState(() => _selectedSkillCategory = index),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),

          // Skill Chips Grid
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Wrap(
              key: ValueKey('$_selectedSkillCategory-${theme.palette}'),
              spacing: 12,
              runSpacing: 12,
              children: currentCategory.skills.map((skill) {
                return InteractiveSkillChip(
                  label: skill,
                  accentColor: _selectedSkillCategory == 0
                      ? theme.primaryLight
                      : (_selectedSkillCategory == 1
                            ? theme.accent
                            : (_selectedSkillCategory == 2
                                  ? theme.secondary
                                  : theme.primaryLight)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // PROFESSIONAL EXPERIENCE SECTION
  Widget _buildExperienceSection(PortfolioThemeData theme) {
    final experiences = [
      const Experience(
        role: 'Flutter Developer',
        company: 'Go Smart Solution',
        period: 'Apr 2025 - Present',
        isCurrent: true,
        description: 'Architecting enterprise-grade cross-platform POS systems and retail checkout applications across Windows Desktop and mobile platforms.',
        keyAchievements: [
          'Engineered seamless commercial POS checkout workflows handling multi-currency, tax calculation, and fast item search.',
          'Integrated hardware drivers for ESC/POS thermal receipt printers and barcode scanners via custom platform channels.',
          'Optimized offline-first data caching with SQLite/Hive to ensure zero transaction interruption during network dropouts.',
        ],
        technologies: [
          'Flutter Desktop',
          'BLoC/Cubit',
          'Clean Architecture',
          'ESC/POS',
          'SQLite',
          'Dio',
        ],
      ),
      const Experience(
        role: 'Flutter Developer',
        company: 'Nation Information Technology',
        period: 'Jan 2025 - Apr 2025',
        isCurrent: false,
        description: 'Designed and deployed modular, maintainable mobile applications implementing strict Clean Architecture standards.',
        keyAchievements: [
          'Restructured legacy codebases into presentation, domain, and data layers, cutting technical debt and increasing feature velocity.',
          'Integrated secure RESTful APIs with Dio interceptors for automated JWT refresh and error handling.',
          'Built responsive layouts matching pixel-perfect Figma designs across various screen dimensions.',
        ],
        technologies: [
          'Flutter',
          'Clean Architecture',
          'Dio',
          'Figma',
          'Provider',
          'Git',
        ],
      ),
      const Experience(
        role: 'Flutter Developer (Internship)',
        company: 'Make Your Marcel',
        period: 'Aug 2023 - Nov 2023',
        isCurrent: false,
        description: 'Collaborated in an agile team to build client-facing mobile applications with predictable state management.',
        keyAchievements: [
          'Implemented responsive UI screens and reusable component libraries.',
          'Gained deep experience in state management patterns using Cubit and BLoC.',
          'Participated in code reviews and sprint planning sessions.',
        ],
        technologies: ['Flutter', 'Cubit', 'Dart', 'REST APIs', 'Firebase'],
      ),
    ];

    return Container(
      key: _experienceKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            theme: theme,
            badge: 'CAREER PATH',
            title: 'Professional Experience',
            subtitle: 'Proven track record of engineering production-ready mobile and desktop solutions.',
          ),
          const SizedBox(height: 32),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              return TimelineItem(
                experience: experiences[index],
                isLast: index == experiences.length - 1,
                theme: theme,
              );
            },
          ),
        ],
      ),
    );
  }

  // FEATURED PROJECTS SECTION (No fixed heights, full responsive wrapping)
  Widget _buildFeaturedProjects(PortfolioThemeData theme) {
    final projects = [
      Project(
        title: 'Stack\'d Burger POS & Ordering',
        tag: 'Mobile & POS Engine',
        description: 'Complete location-aware food ordering app and restaurant POS system with dynamic regional menus and secure digital checkout.',
        icon: Icons.fastfood_rounded,
        gradient: theme.primaryGradient,
        highlights: const [
          'Integrated Fawry and QNB digital payment gateways with real-time webhook confirmations.',
          'Implemented interactive Google Maps geolocation for precise delivery radius dispatching.',
          'Streamlined cart and discount calculations with responsive Provider state management.',
        ],
        technologies: const [
          'Flutter',
          'Provider',
          'Google Maps',
          'Fawry Pay',
          'QNB Gateway',
          'Dio',
        ],
        githubUrl: 'https://github.com/MahmoudEzzat6',
      ),
      Project(
        title: 'Mostasmer',
        tag: 'E-Commerce & Loyalty',
        description: 'Multi-tier promotional e-commerce and loyalty application featuring tiered membership benefits, custom rewards, and promotional flash sales.',
        icon: Icons.storefront_rounded,
        gradient: theme.accentGradient,
        highlights: const [
          'Engineered dynamic tier progression algorithms with automated rewards allocation.',
          'Real-time inventory and orders synchronization with Cloud Firestore.',
          'Push notifications for targeted campaigns using Firebase Cloud Messaging.',
        ],
        technologies: const [
          'Flutter',
          'GetX',
          'Firebase Auth',
          'Cloud Firestore',
          'FCM',
          'REST APIs',
        ],
        githubUrl: 'https://github.com/MahmoudEzzat6',
      ),
      Project(
        title: 'Step2English',
        tag: 'EdTech Streaming',
        description: 'Interactive educational platform designed for children, featuring structured video curriculum, interactive quizzes, and child-safe streaming.',
        icon: Icons.school_rounded,
        gradient: theme.primaryGradient,
        highlights: const [
          'Custom HLS/MP4 video player with playback speed controls, resume-playback, and offline caching.',
          'Interactive gamified progress tracking with animated certificates and rewards.',
          'Lightweight state management using GetX ensuring 60fps performance on low-end devices.',
        ],
        technologies: const [
          'Flutter',
          'GetX',
          'Video Player',
          'In-App Storage',
          'Lottie Animations',
        ],
        githubUrl: 'https://github.com/MahmoudEzzat6',
      ),
      Project(
        title: 'Enterprise Retail POS (Windows/Android)',
        tag: 'Desktop & Retail',
        description: 'Cross-platform Point of Sale engine engineered for high-throughput retail stores, supporting barcode scanners and receipt printers.',
        icon: Icons.point_of_sale_rounded,
        gradient: theme.accentGradient,
        highlights: const [
          'Direct hardware USB/Network connection to ESC/POS thermal printers.',
          'Offline-first architecture storing 50,000+ SKU inventory items locally with SQLite.',
          'Keyboard-first shortcuts optimized for cashier checkout velocity.',
        ],
        technologies: const [
          'Flutter Desktop',
          'Clean Architecture',
          'BLoC',
          'SQLite',
          'ESC/POS',
        ],
        githubUrl: 'https://github.com/MahmoudEzzat6',
      ),
    ];

    return Container(
      key: _projectsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            theme: theme,
            badge: 'PORTFOLIO',
            title: 'Featured Production Projects',
            subtitle: 'Real-world commercial applications built with robust architectures and delightful user experiences.',
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 850;
              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ProjectCard(
                            project: projects[0],
                            onLaunchUrl: _launchUrl,
                            theme: theme,
                          ),
                          const SizedBox(height: 20),
                          ProjectCard(
                            project: projects[2],
                            onLaunchUrl: _launchUrl,
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          ProjectCard(
                            project: projects[1],
                            onLaunchUrl: _launchUrl,
                            theme: theme,
                          ),
                          const SizedBox(height: 20),
                          ProjectCard(
                            project: projects[3],
                            onLaunchUrl: _launchUrl,
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: projects.map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ProjectCard(
                        project: p,
                        onLaunchUrl: _launchUrl,
                        theme: theme,
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // CONTACT & CONNECT SECTION (Opens Gmail directly)
  Widget _buildContactSection(PortfolioThemeData theme) {
    return Container(
      key: _contactKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            theme: theme,
            badge: 'CONNECT',
            title: 'Let\'s Build Something Amazing',
            subtitle: 'Have a project in mind, need a Flutter engineer, or want to discuss architectures? Reach out via Gmail or WhatsApp!',
          ),
          const SizedBox(height: 32),

          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 700;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ContactCard(
                          icon: Icons.mail_rounded,
                          title: 'Direct Google Mail',
                          detail: 'ezzatmahmoud08@gmail.com',
                          actionLabel: 'Click to open Gmail composer',
                          gradient: theme.primaryGradient,
                          theme: theme,
                          onTap: _openGmail,
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: 16),
                      if (isDesktop)
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.chat_rounded,
                            title: 'WhatsApp / Phone',
                            detail: '+20 112 931 16102',
                            actionLabel: 'Chat on WhatsApp',
                            gradient: theme.accentGradient,
                            theme: theme,
                            onTap: () =>
                                _launchUrl('https://wa.me/201129316102'),
                          ),
                        ),
                    ],
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 16),
                    _ContactCard(
                      icon: Icons.chat_rounded,
                      title: 'WhatsApp / Phone',
                      detail: '+20 112 931 16102',
                      actionLabel: 'Chat on WhatsApp',
                      gradient: theme.accentGradient,
                      theme: theme,
                      onTap: () => _launchUrl('https://wa.me/201129316102'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ContactCard(
                          icon: Icons.business_center_rounded,
                          title: 'LinkedIn',
                          detail: 'Mahmoud Ezzat',
                          actionLabel: 'Connect on LinkedIn',
                          gradient: theme.primaryGradient,
                          theme: theme,
                          onTap: () => _launchUrl(
                            'https://www.linkedin.com/in/mahmoud-ezzat-174b41165',
                          ),
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: 16),
                      if (isDesktop)
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.location_on_rounded,
                            title: 'Location',
                            detail: 'Cairo, Egypt (Available Globally)',
                            actionLabel: 'Timezone: GMT+2',
                            gradient: theme.accentGradient,
                            theme: theme,
                            onTap: () {},
                          ),
                        ),
                    ],
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 16),
                    _ContactCard(
                      icon: Icons.location_on_rounded,
                      title: 'Location',
                      detail: 'Cairo, Egypt (Available Globally)',
                      actionLabel: 'Timezone: GMT+2',
                      gradient: theme.accentGradient,
                      theme: theme,
                      onTap: () {},
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // FOOTER
  Widget _buildFooter(PortfolioThemeData theme) {
    return Column(
      children: [
        Divider(color: theme.border, height: 1),
        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 12,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 8,
                //     vertical: 4,
                //   ),
                //   decoration: BoxDecoration(
                //     gradient: theme.primaryGradient,
                //     borderRadius: BorderRadius.circular(6),
                //   ),
                //   child: const Text(
                //     ' ',
                //     style: TextStyle(
                //       fontWeight: FontWeight.w900,
                //       fontSize: 12,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 10),

                Text(
                  'Mahmoud Ezzat • Flutter Portfolio',
                  style: TextStyle(color: theme.textMuted, fontSize: 13),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Palette: ${theme.name} • ',
                  style: TextStyle(
                    color: theme.primaryLight,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Crafted with Flutter & Dart',
                  style: TextStyle(color: theme.textMuted, fontSize: 12.5),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Section Header Helper
  Widget _buildSectionHeader({
    required PortfolioThemeData theme,
    required String badge,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
          ),
          child: Text(
            badge,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: theme.primaryLight,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: theme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              color: theme.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackToTopButton(PortfolioThemeData theme) {
    return FloatingActionButton.small(
      backgroundColor: theme.primary,
      onPressed: () {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      },
      child: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
    );
  }
}

// Helper Buttons
class _GradientButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final PortfolioThemeData theme;

  const _GradientButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.theme,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          transform: _isHovered
              ? Matrix4.translationValues(0.0, -2.0, 0.0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            gradient: t.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: t.primary.withValues(alpha: _isHovered ? 0.6 : 0.35),
                blurRadius: _isHovered ? 20 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
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

class _OutlinedIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final PortfolioThemeData theme;

  const _OutlinedIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.theme,
  });

  @override
  State<_OutlinedIconButton> createState() => _OutlinedIconButtonState();
}

class _OutlinedIconButtonState extends State<_OutlinedIconButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          transform: _isHovered
              ? Matrix4.translationValues(0.0, -2.0, 0.0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? Colors.white70 : t.borderGlow,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final PortfolioThemeData theme;

  const _SocialIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(12),
            transform: _isHovered
                ? Matrix4.diagonal3Values(1.1, 1.1, 1.0)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: _isHovered ? t.primary.withValues(alpha: 0.2) : t.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _isHovered ? t.primaryLight : t.border),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: _isHovered ? t.primaryLight : t.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final String actionLabel;
  final Gradient gradient;
  final VoidCallback onTap;
  final PortfolioThemeData theme;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.actionLabel,
    required this.gradient,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      onTap: onTap,
      borderRadius: 14,
      padding: const EdgeInsets.all(20),
      glowColor: theme.primary,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryLight,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: theme.textMuted,
          ),
        ],
      ),
    );
  }
}
