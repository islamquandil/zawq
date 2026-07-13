/// A user's review of a restaurant.
class Review {
  const Review({
    required this.rating,
    required this.dishes,
    required this.description,
    required this.photoCount,
  });

  final double rating;
  final List<String> dishes;
  final String description;
  final int photoCount;
}
