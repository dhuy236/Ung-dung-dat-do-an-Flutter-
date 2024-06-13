import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/pages/account/account_page.dart';
import 'package:my_app/pages/auth/sign_in_page.dart';
import 'package:my_app/pages/auth/sign_up_page.dart';
import 'package:my_app/pages/cart/cart_history.dart';
import 'package:my_app/pages/cart/cart_page.dart';
import 'package:my_app/pages/home/main_food_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex=0;
  late PersistentTabController _controller;

  List pages=[
    MainFoodPage(),
    CartPage(),
    CartHistory(),
    AccountPage(),
  ];
  void onTapNav(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

@override
void initState(){
  super.initState();
  lateInit();
}
void lateInit(){
  _controller = PersistentTabController(initialIndex: 0);
}

List<Widget> _buildScreens() {
        return [
    MainFoodPage(),
    CartPage(),
    CartHistory(),
    AccountPage(),
        ];
    }

List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.home),
                title: ("Trang chủ"),
                activeColorPrimary: Color.fromARGB(255, 37, 204, 184),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.cart_fill),
                title: ("Giỏ hàng"),
                activeColorPrimary: Color.fromARGB(255, 37, 204, 184),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.history),
                title: ("Đơn hàng"),
                activeColorPrimary: Color.fromARGB(255, 37, 204, 184),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.person),
                title: ("Cá nhân"),
                activeColorPrimary: Color.fromARGB(255, 37, 204, 184),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
        ];
    }
@override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}