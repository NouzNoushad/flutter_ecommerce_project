import 'package:flutter/material.dart';

import 'cart.dart';
import 'database/db.dart';
import 'home.dart';
import 'profile.dart';
import 'wishlist.dart';

class HomeBottomNavBar extends StatefulWidget {
  final String? username;
  const HomeBottomNavBar({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  // select initial index of navbar
  int _selectedIndex = 0;
  Widget getWidgets(index) {
    switch (index) {
      case 0:
        return const ProductsHomePage();
      case 1:
        return ProductsCart(
          username: widget.username!,
        );
      case 2:
        return ProductsWishlist(
          username: widget.username!,
        );
      case 3:
        return ProductProfile(
          username: widget.username!,
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: "You",
          ),
        ],
      ),
      body: getWidgets(_selectedIndex),
    );
  }
}
