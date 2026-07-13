/// A curated list of restaurants — community-authored or the user's own.
class FoodList {
  const FoodList({
    required this.id,
    required this.title,
    required this.author,
    required this.handle,
    required this.colorValue,
    required this.restaurantIds,
    this.description = '',
    this.isMine = false,
  });

  final String id;
  final String title;
  final String author;
  final String handle;
  final int colorValue;
  final List<int> restaurantIds;
  final String description;
  final bool isMine;

  FoodList copyWith({List<int>? restaurantIds}) => FoodList(
        id: id,
        title: title,
        author: author,
        handle: handle,
        colorValue: colorValue,
        restaurantIds: restaurantIds ?? this.restaurantIds,
        description: description,
        isMine: isMine,
      );
}
