/// Whose ratings drive the map pins.
enum WhoFilter { anyone, friends, me }

/// Geographic scope of the map.
enum WhereFilter { nearMe, everywhere }

/// Immutable filter state applied to the discovery map.
class MapFilters {
  const MapFilters({
    this.cuisines = const <String>{},
    this.friendsOnly = false,
    this.michelin = const <String>{},
  });

  final Set<String> cuisines;
  final bool friendsOnly;
  final Set<String> michelin;

  bool get isActive =>
      cuisines.isNotEmpty || friendsOnly || michelin.isNotEmpty;

  MapFilters copyWith({
    Set<String>? cuisines,
    bool? friendsOnly,
    Set<String>? michelin,
  }) =>
      MapFilters(
        cuisines: cuisines ?? this.cuisines,
        friendsOnly: friendsOnly ?? this.friendsOnly,
        michelin: michelin ?? this.michelin,
      );

  static const cleared = MapFilters();
}
