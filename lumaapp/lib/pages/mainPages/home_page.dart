import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:lumaapp/pages/mainPages/user_information_page.dart';
import 'package:lumaapp/pages/mainPages/add_location.dart';
import 'package:lumaapp/widgets/username.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../utils.dart' as utils;
import '../../widgets/bottom_sheet_navigator_extension.dart';
import '../../widgets/tem.dart' show AppTheme, ThemeManager;
import '../modulePages/location_page.dart';
import '../startPages/loginandsignup_1.dart';
import 'package:shimmer/shimmer.dart'; // ✅ اضافه شدن پکیج Shimmer

class LocationCardModel {
  final int id;
  final String name;
  final String location;
  final int countOfProducts;

  LocationCardModel({
    required this.id,
    required this.name,
    required this.location,
    required this.countOfProducts,
  });

  factory LocationCardModel.fromJson(Map<String, dynamic> json) {
    return LocationCardModel(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        countOfProducts: json['countOfProducts']);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// تابع API برای دریافت لیست مکان‌ها
Future<List<LocationCardModel>> fetchLocationCards() async {
  final response = await http.get(
    Uri.parse('${utils.serverAddress}/products/location/generics'),
    headers: {
      'Authorization': 'Token ${utils.token}',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => LocationCardModel.fromJson(json)).toList();
  } else {
    // در صورت بروز خطا، یک Exception پرتاب شود تا توسط FutureBuilder مدیریت شود
    throw Exception('Failed to load cards. Status: ${response.statusCode} | Token: ${utils.token}');
  }
}

class _HomePageState extends State<HomePage> {
  String _currentUsername = '';
  int _tabIndex = 0;
  late PageController _pageController;
  List<Map<String, dynamic>> modulePlacements = [];
  late Future<List<LocationCardModel>> futureLocationCards;
  String mobile = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadInitialData();
  }

  Future<void> _loadmobile() async{
    final prefs = await SharedPreferences.getInstance();
    mobile = prefs.getString('mobileNumber') ?? '';
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    setState(() {
      _currentUsername = username;
    });
  }

  Future<void> _loadTokenAndSetGlobally() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      utils.token = token;
    }
  }

  Future<void> _loadInitialData() async {
    await _loadTokenAndSetGlobally();
    await _loadmobile();
    await _loadUsername();

    setState(() {
      futureLocationCards = fetchLocationCards();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ویجت کمکی: ساختار یک کارت مکان مبهم (Placeholder)
  Widget _buildShimmerLoadingCard(Size size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * 0.024,
        bottom: size.height * 0.034,
        right: size.width * 0.063,
        left: size.width * 0.031,
      ),
      child: Container(
        height: size.height * 0.256,
        width: size.width * 0.333,
        // رنگ پایه برایPlaceholder، Shimmer افکت را روی آن اعمال می‌کند
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white12 : Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(size.width * 0.042),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Placeholder برای عکس/آیکون
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Container(
                height: 80,
                width: size.width * 0.25,
                color: isDarkMode ? Colors.white24 : Colors.grey[300], // رنگ داخلی
              ),
            ),
            // Placeholder برای نام
            Container(
              height: 15,
              width: size.width * 0.2,
              color: isDarkMode ? Colors.white24 : Colors.grey[300],
            ),
            const SizedBox(height: 8),
            // Placeholder برای تعداد
            Container(
              height: 10,
              width: size.width * 0.15,
              color: isDarkMode ? Colors.white24 : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  // ویجت کمکی: لیست Shimmer برای حالت بارگذاری
  Widget _buildLoadingShimmer(Size size, bool isDarkMode) {
    return Shimmer.fromColors(
      // تنظیم رنگ‌ها بر اساس تم تیره/روشن
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: 3, // نمایش 3 کارت مبهم
        itemBuilder: (context, index) {
          return _buildShimmerLoadingCard(size, isDarkMode);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    final userManager = Provider.of<UserManager>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        children: [
          _buildMainContent(),
          const Center(
            child: Text(
              "صفحه تنظیمات",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFF000AAB),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: isDarkMode
                  ?  const Color(0xFF00B04F)
                  :  const Color(0xFF21DB2A),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              userManager.username,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(Icons.person, color: Colors.grey, size: 50),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        themeManager.currentTheme == AppTheme.dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        themeManager.toggleTheme();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: isDarkMode
                    ?  Colors.black // رنگ‌های تم تیره
                    :  Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInformationPage()),
                          );
                        },
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.edit, color: isDarkMode
                                ?  Colors.white
                                :  Colors.black,),
                            const SizedBox(width: 10),
                            Text(
                              s.edit,
                              style: TextStyle(color: isDarkMode
                                  ?  Colors.white
                                  :  Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    const Divider(color: Colors.white54),
                    ListTile(
                      title:  Text(
                        s.logout,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: isDarkMode
                            ?  Colors.white
                            :  Colors.black),
                      ),
                      leading: Icon(Icons.logout, color: isDarkMode
                          ?  Colors.white
                          :  Colors.black),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginSignupScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.white54),
                    ListTile(
                      title: Text(
                        s.delacco,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: isDarkMode
                            ?  Colors.white
                            :  Colors.black),
                      ),
                      leading: Icon(Icons.delete, color: isDarkMode
                          ?  Colors.white
                          :  Colors.black),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.ltr,
        child: CircleNavBar(
          activeIcons: [
            Image.asset(
              'images/bottomNavigationBar/HomeIconMenu.png',
              width: 30,
              height: 30,
            ),
            Image.asset(
              'images/bottomNavigationBar/OnlineSupportIconMenu.png',
              width: 30,
              height: 30,
            ),
          ],
          inactiveIcons: [
            Image.asset(
              'images/bottomNavigationBar/HomeIconMenu.png',
              width: 30,
              height: 30,
            ),
            Image.asset(
              'images/bottomNavigationBar/OnlineSupportIconMenu.png',
              width: 30,
              height: 30,
            ),
          ],
          color: isDarkMode
              ?  const Color(0xFF0100C4)
              :  const Color(0xFF3F5FFF),
          height: 60,
          circleWidth: 60,
          circleColor: isDarkMode
              ?  const Color(0xFFBDFFBD).withOpacity(0.80)
              :  const Color(0xFF21DB2A).withOpacity(0.80),
          activeIndex: _tabIndex,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? const [Color(0xFF000AAB), Colors.black]
              : const [Color(0xFF3F5FFF), Colors.white],
          stops: const [0.4, 1],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildAppBar(),
                const SizedBox(height: 20),
                _buildModulePlacement(),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppLocalizations.of(context)!.module,
                    style: TextStyle(color: isDarkMode
                        ?  Colors.white
                        :  Colors.black, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModuleType(
                      title: AppLocalizations.of(context)!.module1,
                      icon: "images/modules/TV.png",
                    ),
                    const SizedBox(height: 60),
                    _buildModuleType(
                      title: AppLocalizations.of(context)!.module2,
                      icon: "images/modules/LightOn.png",
                    ),
                    const SizedBox(height: 60),
                    _buildModuleType(
                      title: AppLocalizations.of(context)!.module3,
                      icon: "images/modules/AirConditioner.png",
                    ),
                    const SizedBox(height: 60),
                    _buildModuleType(
                      title: AppLocalizations.of(context)!.module4,
                      icon: "images/modules/Wi-FiRouter.png",
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    final s = AppLocalizations.of(context)!;
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                  Icons.menu,
                  color: isDarkMode
                      ?  Colors.white
                      :  Colors.black,
                  size: 35
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Text(
            s.home,
            style: TextStyle(
              color: isDarkMode
                  ?  Colors.white
                  :  Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildModulePlacement() {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;

    // ویجتی که در حالت لودینگ نمایش داده می‌شود (Shimmer یا FutureBuilder)
    Widget loadingOrContentWidget;

    if (_isLoading) {
      // حالت اول: بارگذاری اولیه (قبل از تنظیم Future)
      loadingOrContentWidget = _buildLoadingShimmer(size, isDarkMode);
    } else {
      // حالت دوم: استفاده از FutureBuilder برای فچ داده‌ها
      loadingOrContentWidget = FutureBuilder<List<LocationCardModel>>(
        future: futureLocationCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // حالت سوم: Future در حال بارگذاری است (API Call)
            return _buildLoadingShimmer(size, isDarkMode); // ✅ نمایش Shimmer
          } else if (snapshot.hasError) {
            // نمایش خطا در صورت عدم موفقیت API call
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: isDarkMode ? Colors.white : Colors.red)));
          } else {
            final locationCards = snapshot.data!;

            // اگر داده‌ای وجود نداشته باشد، فقط دکمه افزودن را نشان دهیم
            if (locationCards.isEmpty) {
              return Center(
                child: _buildAddCard(size, isDarkMode),
              );
            }

            // نمایش لیست کارت‌ها + کارت افزودن
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: locationCards.length + 1,
              itemBuilder: (context, index) {
                if (index < locationCards.length) {
                  final locationCard = locationCards[index];
                  return GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.024,
                          bottom: size.height * 0.034,
                          right: size.width * 0.063,
                          left: size.width * 0.031),
                      child: Container(
                        height: size.height * 0.256,
                        width: size.width * 0.333,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ?  const Color(0xFFBDFFBD).withOpacity(0.80)
                              :  const Color(0xFF21DB2A).withOpacity(0.80),
                          borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.042),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ?  const Color(0xFFBDFFBD).withOpacity(0.80)
                                  :  const Color(0xFF21DB2A).withOpacity(0.80),
                              offset: const Offset(0, 0),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // ✅ اصلاح مسیر تصویر: استفاده از locationCard.location
                            Image(
                              image: AssetImage("images/locations/${locationCard.location}.png"),
                              width: size.width * 0.333,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    locationCard.name,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: const Color(0xFF1D1A39),
                                      fontFamily: "Sans",
                                      fontSize: size.width * 0.040,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.count(locationCard.countOfProducts.toString()),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: const Color(0xFF1D1A39),
                                      fontFamily: "Sans",
                                      fontSize: size.width * 0.025,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationPage(locationcard: locationCard),
                        ),
                      );
                    },
                  );
                } else {
                  // کارت آخر = کارت افزودن
                  return _buildAddCard(size, isDarkMode);
                }
              },
            );
          }
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: size.width * 0.073),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                AppLocalizations.of(context)!.loc,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isDarkMode
                      ?  Colors.white
                      :  Colors.black,
                  fontFamily: "Sans",
                  fontSize: size.width * 0.050,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: size.height * 0.314,
          width: size.width,
          child: loadingOrContentWidget, // ✅ نمایش Shimmer یا محتوای اصلی
        ),
      ],
    );
  }

  // ویجت کمکی برای ساخت کارت افزودن (کارت آخر در لیست)
  Widget _buildAddCard(Size size, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        BuildContextTnBottomSheetNav(context).showTnBottomSheetNav(
          'AddLocationOrProduct',
          params: {'mobileNumber': mobile},
          settings: const TnBottomSheetSettings(
            isDismisable: true,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: size.height * 0.024,
            bottom: size.height * 0.034,
            right: size.width * 0.063,
            left: size.width * 0.031),
        child: Container(
          height: size.height * 0.256,
          width: size.width * 0.333,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(size.width * 0.042),
            ),
            border: Border.all(color: Colors.white54, width: 2),
          ),
          child: Center(
            child: Icon(Icons.add, color: isDarkMode
                ?  Colors.white
                :  Colors.black, size: 48),
          ),
        ),
      ),
    );
  }


  Widget _buildModuleType({required String title, required String icon}) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(color: isDarkMode
                ?  Colors.white
                :  Colors.black, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Image.asset(
            icon,
            height: 60,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
