/// A restaurant with everything the UI needs to render discovery,
/// detail, menu, and contact actions.
class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.priceLevel,
    required this.rating,
    required this.googleRating,
    required this.mapX,
    required this.mapY,
    required this.address,
    required this.opensAt,
    required this.isClosed,
    required this.cuisine,
    required this.phone,
    required this.website,
    required this.friendsPick,
    required this.hours,
    required this.dishes,
    required this.photoColors,
    required this.heroColor,
    this.michelin,
    this.video,
  });

  final int id;
  final String name;
  final String category;

  /// 1 = $, 2 = $$, 3 = $$$.
  final int priceLevel;
  final double rating;
  final double googleRating;

  /// Fractional position on the stylized map canvas (0–1).
  final double mapX;
  final double mapY;

  final String address;
  final String opensAt;
  final bool isClosed;
  final String cuisine;
  final String phone;
  final String website;
  final bool friendsPick;

  /// Seven entries, Monday first.
  final List<String> hours;
  final List<String> dishes;

  /// Placeholder photo swatches until real media lands.
  final List<int> photoColors;
  final int heroColor;

  /// Michelin distinction key: `one|two|three|guide|bib|green`, or null.
  final String? michelin;
  final FeaturedVideo? video;

  String get priceLabel => r'$' * priceLevel;
}

class FeaturedVideo {
  const FeaturedVideo({required this.handle, required this.label});
  final String handle;
  final String label;

  String get url => 'https://www.tiktok.com/@$handle';
}
