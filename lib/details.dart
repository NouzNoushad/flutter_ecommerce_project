import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'database/db.dart';
import 'model/products.dart';

class ProductDetails extends StatefulWidget {
  late Products product;
  ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // List of all products data from model
  List<Products> relatedProducts = productsList;
  // database
  MyDb myDb = MyDb();

  @override
  void initState() {
    myDb.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: widget.product.color,
        title: const Text("Details"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              ClipPath(
                clipper: CustomClipperDesign(),
                child: Container(
                  height: 40,
                  color: widget.product.color,
                ),
              ),
              Positioned(
                  top: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 320,
                        width: width - 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/${widget.product.image}",
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rs.${widget.product.price}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            widget.product.productName,
                                            style: const TextStyle(
                                              fontSize: 21,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            widget.product.productWeight,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 100,
                                            child: RatingBar.builder(
                                              itemCount: 5,
                                              itemSize: 20,
                                              allowHalfRating: true,
                                              initialRating:
                                                  widget.product.rating,
                                              itemBuilder: (context, _) {
                                                return const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                );
                                              },
                                              onRatingUpdate: (rating) {
                                                setState(() {
                                                  widget.product.rating =
                                                      rating;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "(${widget.product.rating})",
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.product.isFavorite =
                                          !widget.product.isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: widget.product.isFavorite
                                        ? Colors.red
                                        : Colors.grey.shade400,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: width - 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        // color: Colors.yellow,
                        alignment: Alignment.center,
                        child: const Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Related Items",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            relatedItemsList(width),
                          ],
                        ),
                      ),
                    ],
                  )),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () async {
                    await myDb.db!.rawInsert(
                        "INSERT INTO products (image, productName, productWeight, price) VALUES (?, ?, ?, ?)",
                        [
                          widget.product.image,
                          widget.product.productName,
                          widget.product.productWeight,
                          widget.product.price
                        ]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.amber,
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
                  child: Container(
                    height: 60,
                    width: width,
                    alignment: Alignment.center,
                    color: widget.product.color,
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget relatedItemsList(double width) => Container(
        height: 180,
        width: width - 20,
        margin: const EdgeInsets.only(top: 10),
        // color: Colors.yellow,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            final product = relatedProducts[index];
            return Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(15),
              color: Colors.white,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        onTap: () {
                          setState(() {
                            product.isFavorite = !product.isFavorite;
                          });
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
                        onTap: () {
                          setState(() {
                            product.isWishlist = !product.isWishlist;
                          });
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
            );
          },
        ),
      );
}

class CustomClipperDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    path.lineTo(0, height);
    path.quadraticBezierTo(width / 2, height - 40, width, height);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
