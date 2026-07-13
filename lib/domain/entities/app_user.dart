/// A rating reference shown on a user's mini-profile.
class RatedRef {
  const RatedRef(this.restaurantId, this.score);
  final int restaurantId;
  final double score;
}

/// Another Zawq user (creator, friend, or followed account).
class AppUser {
  const AppUser({
    required this.name,
    required this.verified,
    required this.colorValue,
    required this.trustedBy,
    required this.rated,
  });

  final String name;
  final bool verified;
  final int colorValue;
  final int trustedBy;
  final List<RatedRef> rated;
}
