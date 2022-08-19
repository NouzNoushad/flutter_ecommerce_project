import 'package:flutter/material.dart';

import 'database/db.dart';
import 'details.dart';
import 'model/products.dart';

class ProductsHomePage extends StatefulWidget {
  const ProductsHomePage({Key? key}) : super(key: key);

  @override
  State<ProductsHomePage> createState() => _ProductsHomePageState();
}

class _ProductsHomePageState extends State<ProductsHomePage> {
  // list of veg, fruit or all options
  List<Map<String, dynamic>> iconImages = [
    {
      "image": "fruit_veg_icon.png",
      "color": Colors.blue.withOpacity(0.5),
      "height": 40.0,
      "type": "Veg & Fruit"
    },
    {
      "image": "vegi_icon.png",
      "color": Colors.green.withOpacity(0.5),
      "height": 35.0,
      "type": "Vegetable",
    },
    {
      "image": "fruit_icon.png",
      "color": Colors.orange.withOpacity(0.5),
      "height": 30.0,
      "type": "Fruit"
    },
  ];

  // database
  MyDb myDb = MyDb();
  // List of all products data from model
  List<Products> products = productsList;
  // initializing search product list
  var searchProducts;
  // initialize user searched product's empty as false
  bool isProductsEmpty = false;

  @override
  void initState() {
    myDb.open();
    searchProducts = List.from(products);
    super.initState();
  }

  // filter products while searching
  void filterProducts(String value) {
    setState(() {
      searchProducts = productsList.where((search) {
        var searchName = search.productName.toLowerCase();
        var userTyped = value.toLowerCase();
        return searchName.contains(userTyped);
      }).toList();
    });
    isProductsEmpty = (searchProducts.length == 0) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.orange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        color: Colors.white,
                        child: TextField(
                          onChanged: (value) => filterProducts(value),
                          cursorColor: Colors.grey,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search products",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade400),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: iconImages.length,
                    itemBuilder: (context, index) {
                      final iconImage = iconImages[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            String type =
                                iconImage["type"].toString().toLowerCase();
                            print(type);
                            if (type == "veg & fruit".toLowerCase()) {
                              searchProducts = List.from(productsList);
                              print(searchProducts);
                            } else {
                              searchProducts = productsList.where((type) {
                                String productType =
                                    type.productType.toLowerCase();
                                String iconType = iconImage["type"];
                                return productType
                                    .contains(iconType.toLowerCase());
                              }).toList();
                            }
                          });
                        },
                        child: Container(
                          width: 70,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: iconImage["color"],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/${iconImage["image"]}",
                                height: iconImage["height"],
                                fit: BoxFit.cover,
                              ),
                              Text(
                                iconImage["type"],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                titleLabelWidget("new arrivals", Colors.red),
                newArrivalsListView(),
                titleLabelWidget("daily needs", Colors.green.shade900),
                dailyNeedsListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dailyNeedsListView() => Container(
        height: 260,
        margin: const EdgeInsets.only(top: 10),
        // color: Colors.yellow,
        child: isProductsEmpty
            ? Center(
                child: Text(
                  "No Products",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.withOpacity(0.5),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchProducts.length,
                itemBuilder: (context, index) {
                  final product = searchProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetails(product: product),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(width: 1, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/${product.image}",
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Rs.${product.price}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    product.productName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.productWeight,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    product.isFavorite = !product.isFavorite;
                                  });
                                  if (product.isFavorite == true) {
                                    await myDb.db!.rawInsert(
                                        "INSERT INTO favorites (image, productName, productWeight, price) VALUES(?, ?, ?, ?);",
                                        [
                                          product.image,
                                          product.productName,
                                          product.productWeight,
                                          product.price
                                        ]);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.white,
                                            content: Text(
                                              "Product added to wishlist",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                            )));
                                  }
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: product.isFavorite
                                      ? Colors.red
                                      : Colors.grey.shade400,
                                  size: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    product.isWishlist = !product.isWishlist;
                                  });
                                  if (product.isWishlist == true) {
                                    await myDb.db!.rawInsert(
                                        "INSERT INTO products (image, productName, productWeight, price) VALUES (?, ?, ?, ?)",
                                        [
                                          product.image,
                                          product.productName,
                                          product.productWeight,
                                          product.price
                                        ]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Text(
                                          "Product Added to Cart",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: product.isWishlist
                                      ? Colors.green
                                      : Colors.grey.shade400,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      );

  Widget newArrivalsListView() => Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 10),
        // color: Colors.yellow,
        child: isProductsEmpty
            ? Center(
                child: Text(
                  "No Products",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.withOpacity(0.5),
                  ),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: searchProducts.length,
                itemBuilder: (context, index) {
                  final product = searchProducts[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(product: product),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/${product.image}",
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Rs.${product.price}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  product.productName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  product.productWeight,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 35,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                myDb.db!.rawInsert(
                                    "INSERT INTO products (image, productName, productWeight, price) VALUES (?, ?, ?, ?)",
                                    [
                                      product.image,
                                      product.productName,
                                      product.productWeight,
                                      product.price
                                    ]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      "Product Added to Cart",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: product.color,
                              ),
                              child: const Text(
                                "Add to Cart",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            splashRadius: 0.4,
                            onPressed: () async {
                              setState(() {
                                product.isFavorite = !product.isFavorite;
                              });
                              if (product.isFavorite == true) {
                                await myDb.db!.rawInsert(
                                    "INSERT INTO favorites (image, productName, productWeight, price) VALUES(?, ?, ?, ?);",
                                    [
                                      product.image,
                                      product.productName,
                                      product.productWeight,
                                      product.price
                                    ]);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Text(
                                          "Product added to wishlist",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                          ),
                                        )));
                              }
                            },
                            icon: const Icon(
                              Icons.favorite,
                              size: 20,
                            ),
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      );

  Widget titleLabelWidget(String title, Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 20,
            width: 100,
            color: color,
            alignment: Alignment.center,
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            "see all".toUpperCase(),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      );
}
