import '../../domain/entities/app_user.dart';
import '../../domain/entities/food_list.dart';
import '../../domain/entities/restaurant.dart';

/// In-memory seed data. This is the only file to replace when a real
/// backend lands — repositories read exclusively from here.
abstract final class SeedData {
  static List<String> _week(String s) => List<String>.filled(7, s);

  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 1,
      name: 'Madre! Oaxacan Restaurant and Mezcaleria',
      category: 'Mexican restaurant',
      priceLevel: 2,
      rating: 8.0,
      googleRating: 4.5,
      mapX: 0.42,
      mapY: 0.62,
      address: '1261 Cabrillo Ave Ste 100, Torrance, CA 90501, USA',
      opensAt: '11:00 AM',
      isClosed: true,
      cuisine: 'Mexican',
      phone: '+13105550142',
      website: 'https://maps.google.com/?q=Madre+Oaxacan+Torrance',
      friendsPick: true,
      michelin: 'bib',
      hours: _week('11:00 AM – 10:00 PM'),
      dishes: const [
        r'$5 Tacos', 'Birthday Dessert', 'Breakfast the Oaxacan Way', 'Brunch',
        'Comida Palms', 'Comida Santa Clarita', 'Comida Torrance',
        'Comida West Hollywood', 'Lamb Barbacoa', 'Margaritas', 'Oaxacan Food',
        'Oaxacan Mole', 'Oaxacan Specialties', 'Pozole', 'Tacos', 'Taco Tuesday',
      ],
      photoColors: const [0xFFD8A048, 0xFF8B4513, 0xFFC46B3A],
      heroColor: 0xFF3E2C23,
      video: const FeaturedVideo(handle: 'grubwithgreg', label: 'Grub with Greg'),
    ),
    Restaurant(
      id: 2,
      name: "rachel's ginger beer - u village",
      category: 'Bar',
      priceLevel: 2,
      rating: 9.4,
      googleRating: 4.6,
      mapX: 0.58,
      mapY: 0.38,
      address: '4626 26th Ave NE, Seattle, WA 98105, USA',
      opensAt: '10:00 AM',
      isClosed: true,
      cuisine: 'Bar',
      phone: '+12065550117',
      website: 'https://maps.google.com/?q=rachels+ginger+beer+u+village',
      friendsPick: true,
      hours: _week('10:00 AM – 9:00 PM'),
      dishes: const [
        'Moscow Mule', 'Frozen Cocktail', 'Fried Chicken Sandwich',
        'Mac Salad', 'Dole Whip Float',
      ],
      photoColors: const [0xFFE8B04B, 0xFF23272B, 0xFFF4C542],
      heroColor: 0xFF20262E,
    ),
    Restaurant(
      id: 3,
      name: "Howlin' Ray's Hot Chicken - Chinatown",
      category: 'Southern restaurant',
      priceLevel: 2,
      rating: 9.1,
      googleRating: 4.7,
      mapX: 0.30,
      mapY: 0.44,
      address: '727 N Broadway #128, Los Angeles, CA 90012, USA',
      opensAt: '11:00 AM',
      isClosed: true,
      cuisine: 'American',
      phone: '+12135550183',
      website: 'https://maps.google.com/?q=Howlin+Rays+Chinatown',
      friendsPick: false,
      michelin: 'guide',
      hours: _week('11:00 AM – 8:00 PM'),
      dishes: const ['The Sando', 'Country Tenders', 'Hot Wings', 'Collard Greens'],
      photoColors: const [0xFFB03A2E, 0xFFE67E22, 0xFF7D3C98],
      heroColor: 0xFF5B2C06,
      video: const FeaturedVideo(handle: 'howlinrays', label: "Howlin' Ray's"),
    ),
    Restaurant(
      id: 4,
      name: 'Bao Chick',
      category: 'Asian fusion',
      priceLevel: 1,
      rating: 8.3,
      googleRating: 4.4,
      mapX: 0.70,
      mapY: 0.55,
      address: '2222 Michelson Dr Ste 212, Irvine, CA 92612, USA',
      opensAt: '11:30 AM',
      isClosed: false,
      cuisine: 'Asian',
      phone: '+19495550129',
      website: 'https://maps.google.com/?q=Bao+Chick+Irvine',
      friendsPick: true,
      hours: _week('11:30 AM – 9:30 PM'),
      dishes: const ['Karaage Bao', 'Spicy Chick Bao', 'Loaded Fries'],
      photoColors: const [0xFFF5CBA7, 0xFF935116, 0xFF1B4F72],
      heroColor: 0xFF2E4053,
    ),
    Restaurant(
      id: 5,
      name: "Dave's Hot Chicken",
      category: 'Fast food',
      priceLevel: 1,
      rating: 7.9,
      googleRating: 4.5,
      mapX: 0.52,
      mapY: 0.72,
      address: '2065 E Katella Ave, Anaheim, CA 92806, USA',
      opensAt: '10:30 AM',
      isClosed: false,
      cuisine: 'Fast Food',
      phone: '+17145550166',
      website: 'https://maps.google.com/?q=Daves+Hot+Chicken+Anaheim',
      friendsPick: false,
      hours: _week('10:30 AM – 11:00 PM'),
      dishes: const ['Sliders', 'Tenders', 'Cheese Fries', 'Shakes'],
      photoColors: const [0xFFC0392B, 0xFFF1C40F, 0xFF273746],
      heroColor: 0xFF7B241C,
    ),
    Restaurant(
      id: 6,
      name: 'bb.q Chicken Fullerton',
      category: 'Korean fried chicken',
      priceLevel: 2,
      rating: 7.6,
      googleRating: 4.3,
      mapX: 0.22,
      mapY: 0.68,
      address: '2323 E Chapman Ave Unit C, Fullerton, CA 92831, USA',
      opensAt: '11:00 AM',
      isClosed: true,
      cuisine: 'Korean',
      phone: '+17145550154',
      website: 'https://maps.google.com/?q=bbq+Chicken+Fullerton',
      friendsPick: false,
      hours: _week('11:00 AM – 10:00 PM'),
      dishes: const ['Golden Original', 'Secret Sauce Wings', 'Tteokbokki'],
      photoColors: const [0xFFD4AC0D, 0xFF943126, 0xFF1A5276],
      heroColor: 0xFF6E2C00,
    ),
  ];

  static const List<AppUser> exploreUsers = [
    AppUser(name: 'kaitlyneats', verified: true, colorValue: 0xFFA7C4BC, trustedBy: 812,
        rated: [RatedRef(2, 9.6), RatedRef(3, 9.2)]),
    AppUser(name: 'sistersnacking', verified: true, colorValue: 0xFFE8C1C5, trustedBy: 640,
        rated: [RatedRef(1, 8.8), RatedRef(4, 8.1)]),
    AppUser(name: 'libbylamont', verified: true, colorValue: 0xFFB8B8D1, trustedBy: 505,
        rated: [RatedRef(3, 9.4), RatedRef(5, 7.5)]),
    AppUser(name: 'mr.chimetime', verified: true, colorValue: 0xFFC9D8B6, trustedBy: 469,
        rated: [RatedRef(6, 8.0), RatedRef(2, 9.0)]),
    AppUser(name: 'thelacountdown', verified: true, colorValue: 0xFFF2E2C4, trustedBy: 388,
        rated: [RatedRef(1, 8.4), RatedRef(3, 9.0)]),
    AppUser(name: 'lifeofcian', verified: true, colorValue: 0xFFBFD7EA, trustedBy: 342,
        rated: [RatedRef(5, 8.2), RatedRef(4, 8.6)]),
    AppUser(name: 'jacksdiningroom', verified: true, colorValue: 0xFF2E5339, trustedBy: 301,
        rated: [RatedRef(2, 9.7), RatedRef(6, 7.2)]),
    AppUser(name: 'tastebudtravels', verified: true, colorValue: 0xFFD9C7B8, trustedBy: 254,
        rated: [RatedRef(4, 8.9), RatedRef(1, 7.9)]),
  ];

  static const List<AppUser> knownUsers = [
    AppUser(name: 'youssefmali', verified: false, colorValue: 0xFFCFCFCF, trustedBy: 3,
        rated: [RatedRef(5, 8.0)]),
    AppUser(name: 'mr.eats305', verified: true, colorValue: 0xFF2F4538, trustedBy: 1204,
        rated: [RatedRef(3, 9.5), RatedRef(1, 8.6)]),
    ...exploreUsers,
  ];

  static const List<String> baseFollowing = ['mr.eats305'];
  static const List<String> baseFriends = ['youssefmali', 'mr.eats305'];

  static const List<String> contacts = [
    'Mohammed Al Sanea', 'Burger Delivery', 'Ahmed Abdul Mohsen', 'Marc Banoub',
    'Ali Amr', 'Hazem Younis', 'Musaab Shami', 'Mahmoud Kamel',
  ];

  static const List<FoodList> communityLists = [
    FoodList(id: 'c1', title: 'top tier fried chicken', author: 'Darian Seilabi',
        handle: 'chelokababinc', colorValue: 0xFF3B3B3B, restaurantIds: [2, 3, 4, 5, 6]),
    FoodList(id: 'c2', title: "NY's Must Haves", author: 'Troy Do',
        handle: 'troydo', colorValue: 0xFF8C6A5D, restaurantIds: [3]),
    FoodList(id: 'c3', title: "Houston's Must Haves", author: 'Troy Do',
        handle: 'troydo', colorValue: 0xFF8C6A5D, restaurantIds: [1, 2, 3, 4, 5, 6]),
    FoodList(id: 'c4', title: "LA's Must Haves", author: 'Troy Do',
        handle: 'troydo', colorValue: 0xFF8C6A5D, restaurantIds: [1, 3, 5, 6]),
    FoodList(id: 'c5', title: "Korea's Must Haves", author: 'Troy Do',
        handle: 'troydo', colorValue: 0xFF8C6A5D, restaurantIds: [6, 4, 2, 1]),
    FoodList(id: 'c6', title: "Japan's Must Haves", author: 'Troy Do',
        handle: 'troydo', colorValue: 0xFF8C6A5D, restaurantIds: [4, 2]),
    FoodList(id: 'c7', title: 'Mi Go-To de tacos en Qro', author: 'Patricio Avila',
        handle: 'patoavila', colorValue: 0xFF5D7052, restaurantIds: [1]),
    FoodList(id: 'c8', title: 'Menorca Must-Trys', author: 'Daniel Kohanof',
        handle: 'dkohanof', colorValue: 0xFF1F2733, restaurantIds: [1, 2, 3, 4, 5, 6]),
  ];

  /// Cuisine chips for the filter sheet: (emoji, label).
  static const List<(String, String)> cuisines = [
    ('🍔', 'Burgers'), ('🍕', 'Pizza'), ('🍱', 'Sushi'), ('🥡', 'Chinese'),
    ('🌮', 'Mexican'), ('🇮🇹', 'Italian'), ('🇮🇳', 'Indian'), ('🇯🇵', 'Japanese'),
    ('🇹🇭', 'Thai'), ('🫒', 'Mediterranean'), ('🍇', 'Acai'), ('🇦🇫', 'Afghan'),
    ('🌍', 'African'), ('🇺🇸', 'American'), ('🥢', 'Asian'), ('🥯', 'Bagels'),
    ('🍞', 'Bakery'), ('🍹', 'Bar'), ('🍺', 'Bar & Grill'), ('🍖', 'BBQ'),
    ('🇧🇷', 'Brazilian'), ('🔍', 'Breakfast'), ('🥞', 'Brunch'), ('🍽️', 'Buffet'),
    ('☕', 'Cafe'), ('🍵', 'Coffee'), ('🥪', 'Deli'), ('🍰', 'Dessert'),
    ('🍔', 'Diner'), ('🍩', 'Donuts'), ('🍟', 'Fast Food'), ('🍷', 'Fine Dining'),
    ('🇫🇷', 'French'), ('🇬🇷', 'Greek'), ('🍦', 'Ice Cream'), ('🇰🇷', 'Korean'),
    ('🇱🇧', 'Lebanese'), ('🥘', 'Middle Eastern'), ('🍺', 'Pub'), ('🍜', 'Ramen'),
    ('🥪', 'Sandwich'), ('🦞', 'Seafood'), ('🇪🇸', 'Spanish'), ('🥩', 'Steakhouse'),
    ('🍵', 'Tea House'), ('🇹🇷', 'Turkish'), ('🥗', 'Vegan'), ('🥦', 'Vegetarian'),
    ('🥘', 'Vietnamese'), ('🍷', 'Wine Bar'),
  ];

  /// Michelin star filter rows: (key, star count).
  static const List<(String, int)> michelinStars = [
    ('one', 1), ('two', 2), ('three', 3),
  ];

  /// Michelin guide distinction rows: (key, glyph, label).
  static const List<(String, String, String)> michelinGuides = [
    ('guide', '❁', 'Michelin Guide'),
    ('bib', '☺', 'Bib Gourmand'),
    ('green', '✿', 'Green Star'),
  ];

  /// Avatar swatches offered in the picker.
  static const List<int> avatarSwatches = [
    0xFF2E6B4F, 0xFF8A5100, 0xFF5D7052, 0xFF8C6A5D, 0xFF1F2733, 0xFFB8B8D1,
  ];
}
