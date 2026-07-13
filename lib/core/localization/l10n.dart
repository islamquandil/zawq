import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';

/// Hand-rolled EN / Modern Standard Arabic strings.
///
/// Kept as typed getters (not a JSON map) so every key is compile-checked
/// and templated strings are real functions.
class L10n {
  const L10n(this.ar);

  /// True when the active locale is Arabic.
  final bool ar;

  String _s(String en, String arb) => ar ? arb : en;

  // Navigation
  String get navMap => _s('Map', 'الخريطة');
  String get navPeople => _s('People', 'الناس');
  String get navLists => _s('Lists', 'القوائم');
  String get navProfile => _s('Profile', 'حسابي');

  // Tabs
  String get tabExplore => _s('Explore', 'استكشف');
  String get tabFriends => _s('Friends', 'الأصدقاء');
  String get tabFollowing => _s('Following', 'أتابعهم');
  String get tabAll => _s('All', 'الكل');
  String get tabMine => _s('My lists', 'قوائمي');

  // Map
  String get searchRest => _s('Search restaurants or dishes', 'ابحث عن مطعم أو طبق');
  String get hitlist => _s('Hitlist', 'المفضلة');
  String get whoAnyone => _s('Anyone', 'الجميع');
  String get whoFriends => _s('Friends', 'الأصدقاء');
  String get whoMe => _s('Only me', 'أنا فقط');
  String get whereNear => _s('Near me', 'قريب مني');
  String get whereEverywhere => _s('Everywhere', 'في كل مكان');
  String get noResults => _s('No places match your search.', 'لا توجد أماكن تطابق بحثك.');

  // Filters
  String get filters => _s('Filters', 'الفلاتر');
  String get clearAll => _s('Clear all filters', 'مسح الكل');
  String get location => _s('LOCATION', 'الموقع');
  String get cuisineL => _s('CUISINE', 'المطبخ');
  String get otherFilters => _s('OTHER FILTERS', 'فلاتر أخرى');
  String get friendsRec =>
      _s('Restaurants my friends recommend', 'مطاعم يوصي بها أصدقائي');
  String get apply => _s('Apply filters', 'تطبيق الفلاتر');
  String get searchCuisine =>
      _s('Search a cuisine, e.g. Italian', 'ابحث عن مطبخ، مثل إيطالي');

  // Restaurant
  String get closedL => _s('CLOSED', 'مغلق');
  String get openL => _s('OPEN', 'مفتوح');
  String get opens => _s('Opens', 'يفتح');
  String get hoursH => _s('HOURS', 'مواعيد العمل');
  List<String> get days => ar
      ? const ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد']
      : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String get save => _s('Save', 'حفظ');
  String get savedBtn => _s('Saved', 'محفوظ');
  String get leaveReview => _s('Leave a review', 'اكتب تقييمًا');
  String get updateReview => _s('Update your review', 'عدّل تقييمك');
  String get featuredVideo => _s('FEATURED VIDEO', 'فيديو مميز');
  String get tapWatch => _s('Tap to watch the review', 'اضغط لمشاهدة التقييم');
  String get noVideos => _s('No videos yet for this spot.', 'لا توجد فيديوهات لهذا المكان بعد.');
  String get openExternal => _s('Open original', 'فتح الأصل');
  String get close => _s('Close', 'إغلاق');
  String get addToList => _s('Add to list', 'أضف لقائمة');
  String get directions => _s('Directions', 'الاتجاهات');
  String get call => _s('Call', 'اتصال');
  String get menuL => _s('Menu', 'المنيو');
  String get share => _s('Share', 'مشاركة');
  String get report => _s('Report issue', 'الإبلاغ عن مشكلة');
  String get menuNote => _s('Sample prices — final menu comes from the restaurant.',
      'أسعار تقريبية — المنيو النهائي من المطعم.');
  String get reportH => _s('Report an issue', 'الإبلاغ عن مشكلة');
  String get rWrongInfo => _s('Incorrect info', 'معلومات خاطئة');
  String get rClosed => _s('Permanently closed', 'مغلق نهائيًا');
  String get rLocation => _s('Wrong location', 'موقع خاطئ');
  String get rOther => _s('Other', 'أخرى');
  String get send => _s('Send report', 'إرسال البلاغ');
  String get toastReport => _s('Thanks — report sent', 'شكرًا — تم إرسال البلاغ');
  String get toastShare => _s('Link copied', 'تم نسخ الرابط');

  // Review flow
  String reviewQ(String n) => ar ? 'كيف كان الأكل في $n؟' : 'How was the food at $n?';
  String get showNumber => _s('SHOW NUMBER RATING', 'إظهار الرقم');
  String get addPhotos => _s('ADD PHOTOS', 'أضف صورًا');
  String get whatOrder => _s('WHAT DID YOU ORDER', 'ماذا طلبت؟');
  String get searchDish => _s('Search or add a dish', 'ابحث أو أضف طبقًا');
  String get leaveDesc => _s('LEAVE A DESCRIPTION', 'اكتب وصفًا');
  String get descPh => _s('What stood out? What should friends order?',
      'ما الذي أعجبك؟ بماذا تنصح أصدقاءك؟');
  String get submit => _s('Submit review', 'إرسال التقييم');
  String toastReview(String r) => ar ? 'تم حفظ التقييم · $r' : 'Review saved · $r';

  // People
  String get fromContacts => _s('FROM YOUR CONTACTS', 'من جهات الاتصال');
  String get invite => _s('Invite', 'دعوة');
  String get invited => _s('Invited ✓', 'تمت الدعوة ✓');
  String get searchPeople => _s('Search people', 'ابحث عن أشخاص');
  String get follow => _s('Follow', 'متابعة');
  String get followingBtn => _s('Following ✓', 'أتابعه ✓');
  String get topRated => _s('TOP RATED', 'الأعلى تقييمًا');
  String toastFollow(String n) => ar ? 'تتابع الآن $n' : 'Following $n';
  String toastUnfollow(String n) => ar ? 'ألغيت متابعة $n' : 'Unfollowed $n';

  // Lists
  String get noListsTitle => _s('You currently have no lists.', 'ليس لديك قوائم بعد.');
  String get noListsBody => _s(
      'Lists keep your top restaurants organized — break them out by cuisine, city, or whatever you wish. Tap + to start one.',
      'نظّم مطاعمك المفضلة في قوائم حسب المطبخ أو المدينة أو كما تشاء. اضغط + للبدء.');
  String get noListsBody2 => _s(
      'Organize your top restaurants by cuisine, city, or whatever you wish.',
      'نظّم مطاعمك المفضلة حسب المطبخ أو المدينة أو كما تشاء.');
  String byLine(String by, int n) => ar
      ? 'بواسطة $by · $n ${n == 1 ? 'مطعم' : 'مطاعم'}'
      : 'By $by · $n restaurant${n == 1 ? '' : 's'}';
  String get far => _s('>100 mi', 'أكثر من ١٦٠ كم');
  String get noRestInList => _s(
      'No restaurants yet. Open any restaurant and choose "Add to list".',
      'لا توجد مطاعم بعد. افتح أي مطعم واختر «أضف لقائمة».');
  String get cancel => _s('Cancel', 'إلغاء');
  String get listName => _s('List name', 'اسم القائمة');
  String get listDesc => _s('Add a description (optional)', 'أضف وصفًا (اختياري)');
  String get createList => _s('Create list', 'إنشاء قائمة');
  String get addToAList => _s('Add to a list', 'أضف إلى قائمة');
  String get noListsYet => _s(
      "You don't have any lists yet — create one to save this spot.",
      'ليس لديك قوائم بعد — أنشئ واحدة لحفظ هذا المكان.');
  String get newList => _s('New list', 'قائمة جديدة');
  String get listSaveBtn => _s('Save list', 'حفظ القائمة');
  String get toastListSaved => _s('List saved to My lists', 'تم حفظ القائمة في قوائمي');
  String get deleteList => _s('Delete list', 'حذف القائمة');
  String get confirmDeleteList => _s('Delete this list?', 'حذف هذه القائمة؟');
  String get deleteL => _s('Delete', 'حذف');
  String get toastListDeleted => _s('List deleted', 'تم حذف القائمة');
  String get toastItemRemoved => _s('Removed from list', 'تمت الإزالة من القائمة');
  String toastList(String n) => ar ? 'تم إنشاء قائمة «$n»' : 'List "$n" created';
  String get toastAdded => _s('Added to list', 'تمت الإضافة إلى القائمة');

  // Profile
  String get trustedBy => _s('TRUSTED BY', 'موثوق من');
  String get visitedL => _s('VISITED', 'زرتها');
  String get savedL => _s('SAVED', 'محفوظة');
  String top8(String first) => ar ? 'أفضل ٨ لـ$first' : "$first's Top 8";
  String get myListsH => _s('My lists', 'قوائمي');
  String get top8Edit => _s('Pick your Top 8', 'اختر أفضل ٨');
  String get top8Hint =>
      _s("Choose from places you've reviewed or saved.", 'اختر من الأماكن التي قيّمتها أو حفظتها.');
  String get top8Empty => _s('Review or save a few places first, then pick your Top 8.',
      'قيّم أو احفظ بعض الأماكن أولًا، ثم اختر أفضل ٨.');
  String get done => _s('Done', 'تم');
  String get visitedSheet => _s("Places you've reviewed", 'أماكن قيّمتها');
  String get savedSheet => _s('Saved places', 'أماكن محفوظة');
  String get emptyVisited => _s('No reviews yet — rate your first spot!', 'لا تقييمات بعد — قيّم أول مكان!');
  String get emptySaved => _s('Nothing saved yet.', 'لا محفوظات بعد.');
  String get shareProfile => _s('Share profile', 'مشاركة الملف');
  String get viewVisited => _s('View visited', 'عرض ما زرته');
  String get viewSaved => _s('View saved', 'عرض المحفوظات');
  String get toastProfileCopied => _s('Profile link copied', 'تم نسخ رابط الملف');

  // Settings
  String get profileTitle => _s('Profile', 'الملف الشخصي');
  String get personalInfo => _s('PERSONAL INFORMATION', 'المعلومات الشخصية');
  String get connectSocials => _s('CONNECT SOCIALS', 'ربط الحسابات');
  String get publicProfile => _s('Public profile', 'حساب عام');
  String get publicSub =>
      _s('Allow other users to find and follow you', 'اسمح للمستخدمين الآخرين بالعثور عليك ومتابعتك');
  String publicGate(int n) => ar
      ? 'أضف صورة شخصية واكتب $n تقييمات إضافية لتفعيل الحساب العام.'
      : 'Add a profile picture and leave $n more review${n == 1 ? '' : 's'} to go public.';
  String publicGateReviews(int n) => ar
      ? 'اكتب $n تقييمات إضافية لتفعيل الحساب العام.'
      : 'Leave $n more review${n == 1 ? '' : 's'} to go public.';
  String get publicGateAvatar =>
      _s('Add a profile picture to go public.', 'أضف صورة شخصية لتفعيل الحساب العام.');
  String get toastPublicOn => _s('Your profile is now public', 'أصبح حسابك عامًا');
  String get saveChanges => _s('Save changes', 'حفظ التغييرات');
  String get toastChanges => _s('Changes saved', 'تم حفظ التغييرات');
  String get importMaps => _s('Import Google Maps', 'استيراد خرائط جوجل');
  String get importH => _s('Import from Google Maps', 'استيراد من خرائط جوجل');
  String get importBody => _s("We'll bring your starred places into Zawq as saved spots.",
      'سنضيف أماكنك المميزة بنجمة إلى المحفوظات في ذوق.');
  String get importDo => _s('Import 3 places', 'استيراد ٣ أماكن');
  String get toastImport => _s('3 places imported to Saved', 'تمت إضافة ٣ أماكن إلى المحفوظات');
  String get support => _s('Contact support', 'تواصل مع الدعم');
  String get logout => _s('Log out', 'تسجيل الخروج');
  String get logoutConfirm => _s('Log out of Zawq?', 'تسجيل الخروج من ذوق؟');
  String get avatarH => _s('Choose a profile photo', 'اختر صورة الملف');
  String get toastAvatar => _s('Profile photo updated', 'تم تحديث الصورة');

  // Save / toasts shared
  String get toastSaved => _s('Saved to your hitlist', 'تم الحفظ في المفضلة');
  String get toastUnsaved => _s('Removed from saved', 'تمت الإزالة من المحفوظات');

  // Fields
  String get firstName => _s('First name', 'الاسم الأول');
  String get lastName => _s('Last name', 'اسم العائلة');
  String get email => _s('Email', 'البريد الإلكتروني');
  String get phone => _s('Phone', 'الهاتف');
  String get nickname => _s('Nickname', 'اللقب');
}

/// Convenience accessor: `final l = ref.l10n;`
extension L10nRef on WidgetRef {
  L10n get l10n => watch(l10nProvider);
}
