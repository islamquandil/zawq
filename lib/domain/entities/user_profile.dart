/// The signed-in user's editable profile.
class UserProfile {
  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.nickname,
    required this.instagram,
    required this.tiktok,
    this.avatarColorValue,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String nickname;
  final String instagram;
  final String tiktok;

  /// Chosen avatar swatch; null until the user picks one.
  final int? avatarColorValue;

  bool get hasAvatar => avatarColorValue != null;
  String get fullName => '$firstName $lastName';
  String get initials => [firstName, lastName]
      .where((s) => s.isNotEmpty)
      .map((s) => s[0].toUpperCase())
      .join();

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? nickname,
    String? instagram,
    String? tiktok,
    int? avatarColorValue,
  }) =>
      UserProfile(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        nickname: nickname ?? this.nickname,
        instagram: instagram ?? this.instagram,
        tiktok: tiktok ?? this.tiktok,
        avatarColorValue: avatarColorValue ?? this.avatarColorValue,
      );
}
