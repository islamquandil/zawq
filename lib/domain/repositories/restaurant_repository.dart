import '../entities/restaurant.dart';

abstract interface class RestaurantRepository {
  List<Restaurant> all();
  Restaurant byId(int id);
}
