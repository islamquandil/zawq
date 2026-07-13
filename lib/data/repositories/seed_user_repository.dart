import '../../domain/entities/app_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/seed_data.dart';

class SeedUserRepository implements UserRepository {
  const SeedUserRepository();

  @override
  List<AppUser> exploreUsers() => SeedData.exploreUsers;

  @override
  AppUser? byName(String name) {
    for (final u in SeedData.knownUsers) {
      if (u.name == name) return u;
    }
    return null;
  }

  @override
  List<String> contacts() => SeedData.contacts;

  @override
  List<String> baseFollowing() => SeedData.baseFollowing;

  @override
  List<String> baseFriends() => SeedData.baseFriends;
}
