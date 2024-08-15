import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profissional_news_app/screens_and_widgets/news_with_filters_screen.dart';
import 'package:profissional_news_app/screens_and_widgets/shared_ui_components.dart';
import 'package:profissional_news_app/screens_and_widgets/home_screen/vertical_list_view_in_home_screen.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String route = "HomePage";
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
  Widget build(BuildContext context) {

    List<Widget> _widgetOptions = <Widget>[
      VerticalListView(),
      StaredItemsListView(),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("assets/images/category_icon.png",color: Colors.teal,),
          onPressed: () {
            Navigator.pushNamed(
              context,
              NewsWithFiltersScreen.route,
            );
          },
        ),
        title: Text(
          'Gareeda',
          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700,color: Colors.teal),
        ),
        centerTitle: true,
        actions: [
          CustomPopupMenuButton(onSelectedAction: () {
          })
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar:BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 40,),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star,size: 40,),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        backgroundColor: Colors.white,
        elevation: 10.0,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
