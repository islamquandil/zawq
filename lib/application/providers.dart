import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/l10n.dart';
import '../domain/entities/app_user.dart';
import '../domain/entities/filters.dart';
import '../domain/entities/food_list.dart';
import '../domain/entities/restaurant.dart';
import '../domain/entities/review.dart';
import '../domain/entities/user_profile.dart';
import '../domain/repositories/list_repository.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../data/repositories/seed_list_repository.dart';
import '../data/repositories/seed_restaurant_repository.dart';
import '../data/repositories/seed_user_repository.dart';

/* ---------------------------- Repositories --------------------------- */

final restaurantRepoProvider =
    Provider<RestaurantRepository>((ref) => const SeedRestaurantRepository());
final listRepoProvider =
    Provider<ListRepository>((ref) => const SeedListRepository());
final userRepoProvider =
    Provider<UserRepository>((ref) => const SeedUserRepository());

/* ------------------------------ Locale ------------------------------- */

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

final l10nProvider = Provider<L10n>(
    (ref) => L10n(ref.watch(localeProvider).languageCode == 'ar'));

/* ------------------------------ Reviews ------------------------------ */

class ReviewsNotifier extends StateNotifier<Map<int, Review>> {
  ReviewsNotifier() : super(const {});

  void submit(int restaurantId, Review review) =>
      state = {...state, restaurantId: review};

  void clear() => state = const {};
}

final reviewsProvider =
    StateNotifierProvider<ReviewsNotifier, Map<int, Review>>(
        (ref) => ReviewsNotifier());

/* ------------------------------- Saved ------------------------------- */

class SavedNotifier extends StateNotifier<Set<int>> {
  SavedNotifier() : super(const {});

  /// Toggles saved state; returns true when the id is now saved.
  bool toggle(int id) {
    final next = {...state};
    final added = next.add(id);
    if (!added) next.remove(id);
    state = next;
    return added;
  }

  void addAll(Iterable<int> ids) => state = {...state, ...ids};

  void clear() => state = const {};
}

final savedProvider =
    StateNotifierProvider<SavedNotifier, Set<int>>((ref) => SavedNotifier());

/* ------------------------------ My lists ----------------------------- */

class MyListsNotifier extends StateNotifier<List<FoodList>> {
  MyListsNotifier(this._profileName) : super(const []);

  final String Function() _profileName;
  int _seq = 0;

  String create(String title, String description) {
    final id = 'm${_seq++}';
    state = [
      FoodList(
        id: id,
        title: title,
        author: _profileName(),
        handle: 'islamqndl',
        colorValue: 0xFFC9EAD3,
        restaurantIds: const [],
        description: description,
        isMine: true,
      ),
      ...state,
    ];
    return id;
  }

  void addRestaurant(String listId, int restaurantId) {
    state = [
      for (final l in state)
        if (l.id == listId && !l.restaurantIds.contains(restaurantId))
          l.copyWith(restaurantIds: [...l.restaurantIds, restaurantId])
        else
          l,
    ];
  }

  void removeRestaurant(String listId, int restaurantId) {
    state = [
      for (final l in state)
        if (l.id == listId)
          l.copyWith(
              restaurantIds:
                  l.restaurantIds.where((id) => id != restaurantId).toList())
        else
          l,
    ];
  }

  void delete(String listId) =>
      state = state.where((l) => l.id != listId).toList();

  /// Copies a community list into the user's lists.
  void saveCommunity(FoodList source) {
    final id = 'm${_seq++}';
    state = [
      FoodList(
        id: id,
        title: source.title,
        author: _profileName(),
        handle: 'islamqndl',
        colorValue: source.colorValue,
        restaurantIds: List.of(source.restaurantIds),
        isMine: true,
      ),
      ...state,
    ];
  }

  void clear() => state = const [];
}

final myListsProvider = StateNotifierProvider<MyListsNotifier, List<FoodList>>(
    (ref) => MyListsNotifier(
        () => ref.read(profileProvider).fullName));

/* ------------------------------ Follows ------------------------------ */

class FollowedNotifier extends StateNotifier<Set<String>> {
  FollowedNotifier(List<String> base) : super({...base});

  /// Toggles follow state; returns true when now following.
  bool toggle(String name) {
    final next = {...state};
    final added = next.add(name);
    if (!added) next.remove(name);
    state = next;
    return added;
  }

  void reset(List<String> base) => state = {...base};
}

final followedProvider = StateNotifierProvider<FollowedNotifier, Set<String>>(
    (ref) => FollowedNotifier(ref.read(userRepoProvider).baseFollowing()));

/* ------------------------------ Invites ------------------------------ */

class InvitedNotifier extends StateNotifier<Set<String>> {
  InvitedNotifier() : super(const {});
  void invite(String name) => state = {...state, name};
  void clear() => state = const {};
}

final invitedProvider = StateNotifierProvider<InvitedNotifier, Set<String>>(
    (ref) => InvitedNotifier());

/* ------------------------------ Profile ------------------------------ */

const defaultProfile = UserProfile(
  firstName: 'Islam',
  lastName: 'Quandil',
  email: 'islamabdulwahab916@gmail.com',
  phone: '+201111171916',
  nickname: 'Jellyfish',
  instagram: 'islamqndl',
  tiktok: '@thejellyfish',
);

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(defaultProfile);

  void update(UserProfile next) => state = next;
  void setAvatar(int colorValue) =>
      state = state.copyWith(avatarColorValue: colorValue);
  void reset() => state = defaultProfile;
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
    (ref) => ProfileNotifier());

final publicProfileProvider = StateProvider<bool>((ref) => false);

/* ------------------------------- Top 8 ------------------------------- */

class Top8Notifier extends StateNotifier<List<int>> {
  Top8Notifier() : super(const []);

  /// Toggles membership, capped at 8 entries.
  void toggle(int id) {
    if (state.contains(id)) {
      state = state.where((e) => e != id).toList();
    } else if (state.length < 8) {
      state = [...state, id];
    }
  }

  void clear() => state = const [];
}

final top8Provider =
    StateNotifierProvider<Top8Notifier, List<int>>((ref) => Top8Notifier());

/* ---------------------------- Map filtering -------------------------- */

final mapQueryProvider = StateProvider<String>((ref) => 'Fried chicken');
final hitlistOnlyProvider = StateProvider<bool>((ref) => false);
final whoProvider = StateProvider<WhoFilter>((ref) => WhoFilter.anyone);
final whereProvider = StateProvider<WhereFilter>((ref) => WhereFilter.nearMe);
final mapFiltersProvider =
    StateProvider<MapFilters>((ref) => MapFilters.cleared);

/// Pins currently visible on the map after every active filter.
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final all = ref.watch(restaurantRepoProvider).all();
  final q = ref.watch(mapQueryProvider).trim().toLowerCase();
  final hitlistOnly = ref.watch(hitlistOnlyProvider);
  final saved = ref.watch(savedProvider);
  final who = ref.watch(whoProvider);
  final where = ref.watch(whereProvider);
  final f = ref.watch(mapFiltersProvider);
  final myReviews = ref.watch(reviewsProvider);

  bool matches(Restaurant r) {
    if (hitlistOnly && !saved.contains(r.id)) return false;
    if (who == WhoFilter.friends && !r.friendsPick) return false;
    if (who == WhoFilter.me && !myReviews.containsKey(r.id)) return false;
    if (where == WhereFilter.nearMe) {
      final dx = r.mapX - 0.5;
      final dy = r.mapY - 0.5;
      if (dx * dx + dy * dy > 0.16) return false;
    }
    if (f.cuisines.isNotEmpty && !f.cuisines.contains(r.cuisine)) return false;
    if (f.friendsOnly && !r.friendsPick) return false;
    if (f.michelin.isNotEmpty &&
        (r.michelin == null || !f.michelin.contains(r.michelin))) {
      return false;
    }
    if (q.isEmpty) return true;
    if (r.name.toLowerCase().contains(q)) return true;
    if (r.cuisine.toLowerCase().contains(q)) return true;
    if (r.category.toLowerCase().contains(q)) return true;
    return r.dishes.any((d) => d.toLowerCase().contains(q));
  }

  return all.where(matches).toList();
});

/* --------------------------- Derived people -------------------------- */

/// Users shown on the Following tab: seed follows + newly followed.
final followingUsersProvider = Provider<List<AppUser>>((ref) {
  final repo = ref.watch(userRepoProvider);
  final followed = ref.watch(followedProvider);
  return [
    for (final name in followed)
      if (repo.byName(name) != null) repo.byName(name)!,
  ];
});

/// Users shown on the Friends tab.
final friendUsersProvider = Provider<List<AppUser>>((ref) {
  final repo = ref.watch(userRepoProvider);
  return [
    for (final name in repo.baseFriends())
      if (repo.byName(name) != null) repo.byName(name)!,
  ];
});

/* ------------------------------ Session ------------------------------ */

/// Resets every piece of in-memory state (logout).
void resetSession(WidgetRef ref) {
  ref.read(reviewsProvider.notifier).clear();
  ref.read(savedProvider.notifier).clear();
  ref.read(myListsProvider.notifier).clear();
  ref.read(invitedProvider.notifier).clear();
  ref.read(top8Provider.notifier).clear();
  ref.read(profileProvider.notifier).reset();
  ref.read(publicProfileProvider.notifier).state = false;
  ref
      .read(followedProvider.notifier)
      .reset(ref.read(userRepoProvider).baseFollowing());
  ref.read(mapQueryProvider.notifier).state = 'Fried chicken';
  ref.read(hitlistOnlyProvider.notifier).state = false;
  ref.read(whoProvider.notifier).state = WhoFilter.anyone;
  ref.read(whereProvider.notifier).state = WhereFilter.nearMe;
  ref.read(mapFiltersProvider.notifier).state = MapFilters.cleared;
}
