import 'package:flutter/material.dart';

import 'bottom_navbar.dart';
import 'database/db.dart';
import 'model/products.dart';

class ProductsWishlist extends StatefulWidget {
  final String username;
  const ProductsWishlist({Key? key, required this.username}) : super(key: key);

  @override
  State<ProductsWishlist> createState() => _ProductsWishlistState();
}

class _ProductsWishlistState extends State<ProductsWishlist> {
  // List of all products data from model
  List<Products> products = productsList;
  // empty list to add all favorites data from database
  List<Map> favoriteList = [];
  // database
  MyDb myDb = MyDb();

  @override
  void initState() {
    myDb.open();
    openFavoriteData();
    super.initState();
  }

  void openFavoriteData() {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      favoriteList = await myDb.db!.rawQuery("SELECT * FROM favorites");
      setState(() {});
    });
  }

  @override
  void dispose() {
    myDb.db!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    num total = favoriteList.fold(0, (prev, value) => prev + value["price"]);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Your WishList",
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
        elevation: 0.0,
      ),
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            cartProductsList(),
            Positioned(
              bottom: 0,
              child: ClipPath(
                clipper: CustomClipperDesign(),
                child: Container(
                  height: 100,
                  width: width,
                  padding: const EdgeInsets.fromLTRB(20, 35, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.shade200,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "Rs.$total",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartProductsList() => Container(
        height: 520,
        margin: const EdgeInsets.all(10),
        // color: Colors.yellow,
        child: ListView(
          children: favoriteList.asMap().entries.map((favorite) {
            return Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  wishlistDetails(favorite.value),
                  wishtlistDeleteFeatures(favorite),
                ],
              ),
            );
          }).toList(),
        ),
      );

  Widget wishtlistDeleteFeatures(
          MapEntry<int, Map<dynamic, dynamic>> favorite) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    products[favorite.key].count++;
                  });
                },
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Color.fromARGB(255, 117, 219, 1),
                  size: 18,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "${products[favorite.key].count}",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (products[favorite.key].count <= 1) {
                      return;
                    }
                    products[favorite.key].count--;
                  });
                },
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: Color.fromARGB(255, 117, 219, 1),
                  size: 18,
                ),
              ),
            ],
          ),
          GestureDetector(
              onTap: () async {
                await myDb.db!.rawDelete("DELETE FROM favorites WHERE id = ?",
                    [favorite.value["id"]]);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.white,
                    content: Text(
                      "Product Removed from the Wishlist",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
                openFavoriteData();
              },
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              )),
        ],
      );

  Widget wishlistDetails(Map<dynamic, dynamic> favorite) => Row(
        children: [
          Image.asset(
            "assets/${favorite["image"]}",
            width: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Rs.${favorite["price"]}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              Text(
                favorite["productName"],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                favorite["productWeight"],
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      );
}

class CustomClipperDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    path.moveTo(width, height);
    path.lineTo(width, height - 70);
    path.quadraticBezierTo(width / 2, 0, 0, height - 70);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
