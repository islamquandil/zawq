import '../../domain/entities/food_list.dart';
import '../../domain/repositories/list_repository.dart';
import '../datasources/seed_data.dart';

class SeedListRepository implements ListRepository {
  const SeedListRepository();

  @override
  List<FoodList> communityLists() => SeedData.communityLists;
}
