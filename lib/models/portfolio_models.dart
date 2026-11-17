import 'package:flutter/material.dart';

class Project {
  final String title;
  final String tag;
  final String description;
  final List<String> technologies;
  final IconData icon;
  final Gradient gradient;
  final String? liveUrl;
  final String? githubUrl;
  final String? appStoreUrl;
  final String? playStoreUrl;
  final String? projectImageUrl;
  final List<String> highlights;

  const Project({
    required this.title,
    required this.tag,
    required this.description,
    required this.technologies,
    required this.icon,
    required this.gradient,
    this.liveUrl,
    this.githubUrl,
    this.highlights = const [],
    this.appStoreUrl,
    this.playStoreUrl,
    this.projectImageUrl,
  });
}

class Experience {
  final String role;
  final String company;
  final String period;
  final String description;
  final List<String> keyAchievements;
  final List<String> technologies;
  final bool isCurrent;

  const Experience({
    required this.role,
    required this.company,
    required this.period,
    required this.description,
    required this.keyAchievements,
    required this.technologies,
    this.isCurrent = false,
  });
}

class SkillCategory {
  final String name;
  final IconData icon;
  final List<String> skills;

  const SkillCategory({
    required this.name,
    required this.icon,
    required this.skills,
  });
}

class GitHubRepo {
  final String name;
  final String description;
  final int stargazersCount;
  final int forksCount;
  final String language;
  final String htmlUrl;
  final String updatedAt;

  const GitHubRepo({
    required this.name,
    required this.description,
    required this.stargazersCount,
    required this.forksCount,
    required this.language,
    required this.htmlUrl,
    required this.updatedAt,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'] ?? '',
      description:
          json['description'] ??
          'Cross-platform application built with Flutter & Dart.',
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      language: json['language'] ?? 'Dart',
      htmlUrl: json['html_url'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
