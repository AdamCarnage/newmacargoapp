import 'package:enquiry/pages/login.dart';
import 'package:enquiry/pages/ma_dashboard.dart';
import 'package:enquiry/pages/notification.dart';
import 'package:enquiry/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:enquiry/pages/profilepage.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ma_dashboard(),
          SettingsScreen(),
          NotificationsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 182, 6, 6),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Style2BottomNavBar(
            navBarConfig: NavBarConfig(
                items: [
                  ItemConfig(
                    icon: const Icon(Icons.home),
                    inactiveIcon: const Icon(Icons.home),
                    title: 'Home',
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  ItemConfig(
                    icon: const Icon(Icons.settings),
                    inactiveIcon: const Icon(Icons.settings),
                    title: 'Settings',
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  ItemConfig(
                    icon: const Icon(Icons.notifications),
                    inactiveIcon: const Icon(Icons.notifications),
                    title: 'Notifications',
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  ItemConfig(
                    icon: const Icon(Icons.person),
                    inactiveIcon: const Icon(Icons.person),
                    title: 'Profile',
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ],
                selectedIndex: _currentIndex,
                onItemSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                    _tabController.animateTo(index);
                  });
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 182, 6, 6),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/abood.png', // Replace with your logo path
              height: 30, // Adjust height as needed
              width: 30, // Adjust width as needed
            ),
            PopupMenuButton<String>(
                offset: const Offset(0, 50), // Position the popup below the dots
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'logout') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogInScreen()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: ListTile(
                          leading: Icon(Icons.logout,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          title: Text('Logout'),
                        ),
                      ),
                    ])
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose the Company',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          height: 1.0,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildCompanyLogo('ABOOD BUS'),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ma_dashboard(),
                                ),
                              );
                            },
                            child: _buildCompanyLogo('MA CARGO'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 140.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.red),
                            ),
                            child: const Center(
                              child: Text('COPEX'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo(String companyName) {
    return Container(
      width: 140.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.red),
      ),
      child: Center(
        child: Text(companyName),
      ),
    );
  }
}

class Style2BottomNavBar extends StatelessWidget {
  const Style2BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.itemPadding = const EdgeInsets.all(5),
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final EdgeInsets itemPadding;
  final ItemAnimation itemAnimationProperties;

  Widget _buildItem(ItemConfig item, bool isSelected, double deviceWidth) {
    return AnimatedContainer(
      width: isSelected ? deviceWidth * 0.29 : deviceWidth * 0.12,
      duration: itemAnimationProperties.duration,
      curve: itemAnimationProperties.curve,
      padding: itemPadding,
      decoration: BoxDecoration(
        color: isSelected ? const Color.fromARGB(255, 182, 6, 6) : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(
              size: 24,
              color: isSelected ? Colors.white : const Color.fromARGB(255, 182, 6, 6),
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
          if (item.title != null && isSelected)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  item.title!,
                  softWrap: false,
                  style: item.textStyle.apply(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      decoration: navBarDecoration,
      height: navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navBarConfig.items.map((item) {
          final int index = navBarConfig.items.indexOf(item);
          return InkWell(
            onTap: () {
              navBarConfig.onItemSelected(index);
            },
            child: _buildItem(
              item,
              navBarConfig.selectedIndex == index,
              MediaQuery.of(context).size.width,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NavBarConfig {
  final List<ItemConfig> items;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final double navBarHeight;

  NavBarConfig({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.navBarHeight = 60.0,
  });
}

class NavBarDecoration {
  final Color color;

  const NavBarDecoration(
      {this.color = const Color.fromARGB(255, 240, 239, 239)});
}

class ItemConfig {
  final Icon icon;
  final Icon inactiveIcon;
  final String? title;
  final TextStyle textStyle;

  ItemConfig({
    required this.icon,
    required this.inactiveIcon,
    this.title,
    required this.textStyle,
  });
}

class ItemAnimation {
  final Duration duration;
  final Curve curve;

  const ItemAnimation({
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });
}

class DecoratedNavBar extends StatelessWidget {
  final NavBarDecoration decoration;
  final double height;
  final Widget child;

  const DecoratedNavBar({super.key, 
    required this.decoration,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: decoration.color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: child,
    );
  }
}
