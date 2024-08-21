import 'package:basketball_frontend/main/BottomNavigationBar/games.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/home.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/search.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/profile/profile.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/notification.dart';
import 'package:basketball_frontend/main/Drawer/drawer.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _openingHive();
    _connectingSock();
  }

  Future<void> _openingHive() async {
    await Hive.openBox('details');
    await Hive.openBox('search');
  }

  Future<void> _connectingSock() async {
    await Connectivity().sock(context);
    
  }

  DateTime timeBackedPressed = DateTime.now();
  Future<bool> _onWillPop() async {
    final diffrence = DateTime.now().difference(timeBackedPressed);
    final isExistingWarning = diffrence >= const Duration(seconds: 2);
    timeBackedPressed = DateTime.now();
    if (isExistingWarning) {
      const message = 'Press back again to exit';
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(message)));
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [diffrentpages(), bottomBar(), const SideDrawer()],
            )),
      ),
    );
  }

  Widget diffrentpages() {
    if (_selectedIndex == 0) {
      return const Home();
    } else if (_selectedIndex == 1) {
      return const SearchData();
    } else if (_selectedIndex == 2) {
      return const AllNotification();
    } else if (_selectedIndex == 4) {
      return const Games();
    } else {
      return const Profile(
        page: 'bottomNavigationBar',
      );
    }
  }

  Widget bottomBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Material(
        color: const Color(0xFFf8843d),
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => _onItemTapped(0),
              icon: const Icon(
                CupertinoIcons.house,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                Provider.of<SearchProvider>(context, listen: false)
                    .settingSearch([]);
                _onItemTapped(1);
              },
              icon: const Icon(
                CupertinoIcons.search,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                Provider.of<SearchProvider>(context, listen: false)
                    .settingSearch([]);
                _onItemTapped(4);
              },
              icon: const Icon(
                CupertinoIcons.sportscourt,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: const Icon(
                CupertinoIcons.heart,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: const Icon(
                CupertinoIcons.person,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
