class PortfolioConfig {
  static const String name = 'Mahmoud Ezzat';
  static const String role = 'Mid-Level Flutter Developer | Mobile & Desktop Engineer';
  static const String email = 'ezzatmahmoud08@gmail.com';
  static const String phone = '+20 112 931 6102';
  
  // Profile image (local asset with web support)
  static const String defaultProfileImageUrl = 'assets/images/profile.png';

  // Global Social Links
  static const String githubUrl = 'https://github.com/MahmoudEzzat6';
  static const String linkedinUrl = 'https://www.linkedin.com/in/mahmoud-ezzat-174b41165';
  static const String whatsappUrl = 'https://wa.me/201129316102';
  static const String location = 'Cairo, Egypt (Available Globally)';
  
  // Direct Google Mail web composer link
  static String get gmailComposerUrl =>
      'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=Project%20Opportunity%20-%20$name';
}
