import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:simple_shadow/simple_shadow.dart';

// --- IMPORTANT: مسیر import صفحه AddLocationOrProduct را بر اساس پروژه‌ات درست کن ---
// در مثال شما در main قبلاً از این مسیر استفاده کرده بودی:
import 'package:lumaapp/pages/mailPages/add_location_or_product_bottom_sheet_page.dart';

// local replacement for the tn_bottom_sheet_navigator helper (no change in main required)
class TnBottomSheetSettings {
  final BoxConstraints? constraints;
  final bool isScrollControlled;
  final bool isDismisable; // kept the original spelling used in your code

  const TnBottomSheetSettings({
    this.constraints,
    this.isScrollControlled = false,
    this.isDismisable = true,
  });
}

extension BuildContextTnBottomSheetNav on BuildContext {
  Future<T?> showTnBottomSheetNav<T>(
      String route, {
        required TnBottomSheetSettings settings,
      }) {
    // resolve route -> widget (add more routes here if needed)
    Widget? child;
    switch (route) {
      case 'AddLocationOrProduct':
        child = const AddLocationOrProduct();
        break;
      default:
        child = null;
    }

    if (child == null) {
      debugPrint('TnBottomSheet: route "$route" not found.');
      return Future.value(null);
    }

    // showModalBottomSheet with the settings the same way your package would
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: settings.isScrollControlled,
      isDismissible: settings.isDismisable,
      enableDrag: settings.isDismisable,
      constraints: settings.constraints,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        // if the route widget is a full scaffold (like your AddLocationOrProduct),
        // returning it directly may be fine. We wrap with SafeArea so it looks correct.
        return SafeArea(
          top: false,
          child: child!,
        );
      },
    );
  }
}

// --------------------------- Your original HomePage (unchanged logic) ---------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;
  late PageController _pageController;
  List<Map<String, dynamic>> modulePlacements = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showAddModuleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        int moduleCount = 0;
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("افزودن مکان جدید", textAlign: TextAlign.right),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "عنوان (مثلاً آشپزخانه)"),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "تعداد ماژول ها"),
                keyboardType: TextInputType.number,
                onChanged: (value) => moduleCount = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("لغو", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("تایید", style: TextStyle(color: Colors.green)),
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    modulePlacements.add({
                      "title": title,
                      "modules": moduleCount,
                      "image": "images/placeholder.jpg",
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFF00B04F),
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
                          children: const [
                            Text(
                              "نام کاربری",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 5),
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
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "ویرایش اطلاعات",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    const Divider(color: Colors.white54),
                    const ListTile(
                      title: Text(
                        "خروج از حساب کاربری",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(Icons.logout, color: Colors.white),
                    ),
                    const Divider(color: Colors.white54),
                    const ListTile(
                      title: Text(
                        "حذف حساب کاربری",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(Icons.delete, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CircleNavBar(
        activeIcons: [
          Image.asset(
            'images/bottomNavigationBar/HomeIconMenu.png',
            width: 30,
            height: 30,
          ),
          const Icon(Icons.settings, color: Colors.white),
        ],
        inactiveIcons: [
          Image.asset(
            'images/bottomNavigationBar/HomeIconMenu.png',
            width: 30,
            height: 30,
            color: Colors.white70,
          ),
          const Icon(Icons.settings, color: Colors.white70),
        ],
        color: const Color(0xFF1100DB),
        height: 60,
        circleWidth: 60,
        circleColor: Colors.green,
        activeIndex: _tabIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000AAB),
            Colors.black,
          ],
          stops: [0.4, 0.8],
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
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "انواع ماژول ها",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                      title: "ماژول کنترل تلویزیون",
                      icon: "images/modules/TV.png",
                    ),
                    const SizedBox(height: 60),
                    _buildModuleType(
                      title: "ماژول روشنایی",
                      icon: "images/modules/LightOn.png",
                    ),
                    const SizedBox(height: 60),
                    _buildModuleType(
                      title: "ماژول کولر",
                      icon: "images/modules/AirConditioner.png",
                    ),
                    const SizedBox(height: 60),
                    _buildModuleType(
                      title: "ماژول وای فای",
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
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 28
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const Text(
            "خانه",
            style: TextStyle(
              color: Colors.white,
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
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "محل قرار گیری ماژول ها",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.showTnBottomSheetNav(
                    'AddLocationOrProduct',
                    settings: TnBottomSheetSettings(
                      constraints: BoxConstraints(
                        maxHeight: size.height * 0.700,
                      ),
                      isScrollControlled: true,
                      isDismisable: true,
                    ),
                  ),
                  child: Container(
                    height: 120,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                ),
                ...modulePlacements.map((module) {
                  return _buildModuleCard(module);
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    return Container(
      width: 100,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(module['image']),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                module['title'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.right,
              ),
              Text(
                "${module['modules']} ماژول",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleType({required String title, required String icon}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.white, fontSize: 14),
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
