import 'package:flutter/material.dart';

import 'bottom_navbar.dart';
import 'cart.dart';
import 'login.dart';
import 'wishlist.dart';

class ProductProfile extends StatefulWidget {
  final String username;
  const ProductProfile({Key? key, required this.username}) : super(key: key);

  @override
  State<ProductProfile> createState() => _ProductProfileState();
}

class _ProductProfileState extends State<ProductProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "You",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => HomeBottomNavBar(
                          username: widget.username,
                        )),
              );
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 35,
                    child: Text(
                      widget.username.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        height: 0.85,
                        fontSize: 50,
                        color: Colors.white,
                        // backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductsCart(
                      username: widget.username,
                    ),
                  ),
                );
              },
              leading: const Icon(
                Icons.list,
                color: Colors.orange,
              ),
              title: const Text(
                "My Orders",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductsWishlist(
                      username: widget.username,
                    ),
                  ),
                );
              },
              leading: const Icon(
                Icons.favorite_border,
                color: Colors.orange,
              ),
              title: const Text(
                "My Favorite",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.wallet_outlined,
                color: Colors.orange,
              ),
              title: const Text(
                "Payment Details",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.settings,
                color: Colors.orange,
              ),
              title: const Text(
                "My Account",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.orange,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
