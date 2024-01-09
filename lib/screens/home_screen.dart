import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:videocoffer/utils/homescreenitem.dart';
import 'package:provider/provider.dart';
import 'package:videocoffer/utils/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 int currentpage = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    context.read<HomeState>().setCurrentPage(page);
    setState(() {
      currentpage = page;
    });
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      currentpage = page;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homescreenitem,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(backgroundColor: Color.fromARGB(255, 9, 3, 91),items: [
        BottomNavigationBarItem(
            icon:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.home, color: currentpage == 0 ? Color.fromARGB(255, 120, 204, 234) :Colors.white),
                ),
            label: '',
            ),
        BottomNavigationBarItem(
            icon:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search, color: currentpage == 1 ?  Color.fromARGB(255, 120, 204, 234) :Colors.white),
                ),
            label: '',
        ),
        BottomNavigationBarItem(
            icon:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add_circle, color: currentpage == 2 ?  Color.fromARGB(255, 120, 204, 234) :Colors.white),
                ),
            label: '',
        ),
        BottomNavigationBarItem(
            icon:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.person, color: currentpage == 3 ?  Color.fromARGB(255,120, 204, 234) :Colors.white),
                ),
            label: '',
            ),
        BottomNavigationBarItem(
            icon:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.update_rounded, color: currentpage == 4 ?  Color.fromARGB(255,120, 204, 234) :Colors.white),
                ),
            label: '',
            ),
      ],
      onTap: navigationTapped),
    );
  }}