import 'package:flutter/material.dart';

import 'bottom_navbar.dart';
import 'database/db.dart';
import 'model/products.dart';

class ProductsCart extends StatefulWidget {
  final String username;
  const ProductsCart({Key? key, required this.username}) : super(key: key);

  @override
  State<ProductsCart> createState() => _ProductsCartState();
}

class _ProductsCartState extends State<ProductsCart> {
  // database
  MyDb myDb = MyDb();
  // List of all products data from model
  List<Products> products = productsList;
  // empty list to add all products data from database
  List<Map> productsData = [];

  @override
  void initState() {
    myDb.open();
    getProductData();
    super.initState();
  }

  void getProductData() {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      productsData = await myDb.db!.rawQuery("SELECT * FROM products");
      setState(() {});
      print(productsData);
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
    num total = productsData.fold(
        0, (previousValue, element) => previousValue + element["price"]);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Your Cart",
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
                  height: 150,
                  width: width,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.shade200,
                  ),
                  child: Column(
                    children: [
                      Row(
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
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.white,
                                content: Text(
                                  "Fill your checkout details",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white),
                          child: const Text(
                            "Continue to Checkout",
                            style: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
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
        height: 470,
        margin: const EdgeInsets.all(10),
        // color: Colors.yellow,
        child: ListView(
          children: productsData.map((product) {
            // find the count of product from model
            var newProducts = productsList.where((newProduct) =>
                newProduct.productName == product["productName"]);
            int count = newProducts.first.count;
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
                  cartDetails(product),
                  cartDeleteFeatures(product, count),
                ],
              ),
            );
          }).toList(),
        ),
      );

  Widget cartDeleteFeatures(Map<dynamic, dynamic> product, int count) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    count++;
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
                "$count",
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
                    if (count <= 1) {
                      return;
                    }
                    count--;
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
                await myDb.db!.rawDelete(
                    "DELETE FROM products WHERE id = ?", [product["id"]]);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text(
                      "Product Removed from the Cart",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
                getProductData();
              },
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              )),
        ],
      );

  Widget cartDetails(Map<dynamic, dynamic> product) => Row(
        children: [
          Image.asset(
            "assets/${product["image"]}",
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
                "Rs.${product["price"]}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              Text(
                product["productName"],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product["productWeight"],
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
    path.lineTo(width, height - 120);
    path.quadraticBezierTo(width / 2, 0, 0, height - 120);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
