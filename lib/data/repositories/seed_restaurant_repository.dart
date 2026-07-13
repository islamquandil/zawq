import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/seed_data.dart';

class SeedRestaurantRepository implements RestaurantRepository {
  const SeedRestaurantRepository();

  @override
  List<Restaurant> all() => SeedData.restaurants;

  @override
  Restaurant byId(int id) =>
      SeedData.restaurants.firstWhere((r) => r.id == id);
}
