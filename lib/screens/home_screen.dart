import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profissional_news_app/model/app_utitlities.dart';
import 'package:profissional_news_app/model/specific_source.dart';
import 'package:profissional_news_app/screens/news_with_filters_screen.dart';
import 'package:profissional_news_app/screens/shared_ui_components.dart';
import 'package:provider/provider.dart';
import '../model/shared.dart';
import '../model/stared_news_provider.dart';

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
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    List<Widget> _widgetOptions = <Widget>[
      SizedBox(
        height: height,
        child: FutureBuilder<List<Articles>>(
          future: fetchEveryThingApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  child: spinKit2,
                ),
              );
            } else if (snapshot.hasError) {
              return Column(
                children: [
                  Text(
                      'Something went wrong, check the connection and try again'),
                  SizedBox(
                    height: 40,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.refresh,
                        size: 32,
                        color: Colors.blueAccent,
                      ))
                ],
              );
            } else {
              return ListView.builder(
                  itemCount: filtered_articles.length,
                  itemBuilder: (context, index) {
                    if (index == 0)
                    {
                      return OutlinedNewsListView(screenHeight: height, screenWidth: width);
                    }
                    else
                    {
                      return CategorizedNewsWidget(screenHeight: height,screenWidth: width,
                        articleDetailsItem:AppUtitlities.extractArticlesDetailsInfo(snapshot.data![index]) ,
                        );
                    }
                  });
            }
          },
        ),
      ),
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
            setState(() {});
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
