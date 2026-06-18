class OpportunityModel {
  final String id;
  final String title;
  final String organization;
  final String location;
  final String category; // Internship, Hackathon, Competition, Scholarship, Research
  final int matchPercentage;
  final List<String> matchReasons;
  final String applyUrl;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.organization,
    required this.location,
    required this.category,
    required this.matchPercentage,
    required this.matchReasons,
    required this.applyUrl,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json, String documentId) {
    return OpportunityModel(
      id: documentId,
      title: json['title'] ?? '',
      organization: json['organization'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? 'Internship',
      matchPercentage: json['matchPercentage'] ?? 0,
      matchReasons: List<String>.from(json['matchReasons'] ?? []),
      applyUrl: json['applyUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'organization': organization,
      'location': location,
      'category': category,
      'matchPercentage': matchPercentage,
      'matchReasons': matchReasons,
      'applyUrl': applyUrl,
    };
  }
}
