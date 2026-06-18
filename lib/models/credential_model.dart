enum CredentialCategory {
  internship,
  certification,
  hackathon,
  competition,
  project,
  workshop,
  research,
  other
}

extension CredentialCategoryExtension on CredentialCategory {
  String get displayName {
    switch (this) {
      case CredentialCategory.internship:
        return 'Internship';
      case CredentialCategory.certification:
        return 'Certification';
      case CredentialCategory.hackathon:
        return 'Hackathon';
      case CredentialCategory.competition:
        return 'Competition';
      case CredentialCategory.project:
        return 'Project';
      case CredentialCategory.workshop:
        return 'Workshop';
      case CredentialCategory.research:
        return 'Research';
      case CredentialCategory.other:
        return 'Other';
    }
  }
}

enum VerificationStatus {
  verified,
  reviewNeeded,
  flagged
}

class CredentialModel {
  final String id;
  final String userId;
  final String title;
  final String organization;
  final String dateAchieved;
  final CredentialCategory category;
  final String description;
  final String certificateUrl;
  final String proofUrl;
  final int verificationScore;
  final Map<String, dynamic> ocrResult;
  final Map<String, dynamic> aiDetectionResult;
  final VerificationStatus status;

  CredentialModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.organization,
    required this.dateAchieved,
    required this.category,
    required this.description,
    required this.certificateUrl,
    required this.proofUrl,
    required this.verificationScore,
    required this.ocrResult,
    required this.aiDetectionResult,
    required this.status,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json, String documentId) {
    CredentialCategory cat = CredentialCategory.other;
    final catStr = json['category']?.toString().toLowerCase();
    for (var value in CredentialCategory.values) {
      if (value.name.toLowerCase() == catStr) {
        cat = value;
        break;
      }
    }

    VerificationStatus stat = VerificationStatus.reviewNeeded;
    final statStr = json['status']?.toString().toLowerCase();
    if (statStr == 'verified') {
      stat = VerificationStatus.verified;
    } else if (statStr == 'flagged') {
      stat = VerificationStatus.flagged;
    }

    return CredentialModel(
      id: documentId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      organization: json['organization'] ?? '',
      dateAchieved: json['dateAchieved'] ?? '',
      category: cat,
      description: json['description'] ?? '',
      certificateUrl: json['certificateUrl'] ?? '',
      proofUrl: json['proofUrl'] ?? '',
      verificationScore: json['verificationScore'] ?? 0,
      ocrResult: Map<String, dynamic>.from(json['ocrResult'] ?? {}),
      aiDetectionResult: Map<String, dynamic>.from(json['aiDetectionResult'] ?? {}),
      status: stat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'organization': organization,
      'dateAchieved': dateAchieved,
      'category': category.name,
      'description': description,
      'certificateUrl': certificateUrl,
      'proofUrl': proofUrl,
      'verificationScore': verificationScore,
      'ocrResult': ocrResult,
      'aiDetectionResult': aiDetectionResult,
      'status': status.name,
    };
  }

  CredentialModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? organization,
    String? dateAchieved,
    CredentialCategory? category,
    String? description,
    String? certificateUrl,
    String? proofUrl,
    int? verificationScore,
    Map<String, dynamic>? ocrResult,
    Map<String, dynamic>? aiDetectionResult,
    VerificationStatus? status,
  }) {
    return CredentialModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      organization: organization ?? this.organization,
      dateAchieved: dateAchieved ?? this.dateAchieved,
      category: category ?? this.category,
      description: description ?? this.description,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      proofUrl: proofUrl ?? this.proofUrl,
      verificationScore: verificationScore ?? this.verificationScore,
      ocrResult: ocrResult ?? this.ocrResult,
      aiDetectionResult: aiDetectionResult ?? this.aiDetectionResult,
      status: status ?? this.status,
    );
  }
}
