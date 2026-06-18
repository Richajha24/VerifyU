class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String college;
  final String branch;
  final int currentYear;
  final int graduationYear;
  final String city;
  final List<String> careerInterests;
  final int trustScore;
  final String portfolioHandle;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.college,
    required this.branch,
    required this.currentYear,
    required this.graduationYear,
    required this.city,
    required this.careerInterests,
    required this.trustScore,
    required this.portfolioHandle,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      college: json['college'] ?? '',
      branch: json['branch'] ?? '',
      currentYear: json['currentYear'] is int ? json['currentYear'] : int.tryParse(json['currentYear']?.toString() ?? '1') ?? 1,
      graduationYear: json['graduationYear'] is int ? json['graduationYear'] : int.tryParse(json['graduationYear']?.toString() ?? '2026') ?? 2026,
      city: json['city'] ?? '',
      careerInterests: List<String>.from(json['careerInterests'] ?? []),
      trustScore: json['trustScore'] ?? 0,
      portfolioHandle: json['portfolioHandle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'college': college,
      'branch': branch,
      'currentYear': currentYear,
      'graduationYear': graduationYear,
      'city': city,
      'careerInterests': careerInterests,
      'trustScore': trustScore,
      'portfolioHandle': portfolioHandle,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? college,
    String? branch,
    int? currentYear,
    int? graduationYear,
    String? city,
    List<String>? careerInterests,
    int? trustScore,
    String? portfolioHandle,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      college: college ?? this.college,
      branch: branch ?? this.branch,
      currentYear: currentYear ?? this.currentYear,
      graduationYear: graduationYear ?? this.graduationYear,
      city: city ?? this.city,
      careerInterests: careerInterests ?? this.careerInterests,
      trustScore: trustScore ?? this.trustScore,
      portfolioHandle: portfolioHandle ?? this.portfolioHandle,
    );
  }
}
