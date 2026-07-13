import '../entities/app_user.dart';

abstract interface class UserRepository {
  List<AppUser> exploreUsers();
  AppUser? byName(String name);
  List<String> contacts();
  List<String> baseFollowing();
  List<String> baseFriends();
}
