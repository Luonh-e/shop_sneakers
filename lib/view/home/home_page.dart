import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneakers_shop/bloc/add_to_cart_bloc.dart';
import 'package:sneakers_shop/bloc/add_to_cart_even.dart';
import 'package:sneakers_shop/model/cart_model.dart';
import 'package:sneakers_shop/model/shoes_model.dart';
import 'package:sneakers_shop/utils/constants.dart';
import 'package:sneakers_shop/view/cart/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Shoe> shoes = [];
  List shoeAdded = [];
  bool showFullDescription = false;
  List<IconData?> buttonIcons = List.generate(100, (index) => null);

  Future<void> fetchData() async {
    try {
      String data = await DefaultAssetBundle.of(context)
          .loadString('assets/data/shoes.json');

      final List<dynamic> jsonData = json.decode(data)['shoes'];
      setState(() {
        shoes = jsonData.map((json) => Shoe.fromJson(json)).toList();
      });
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void addToCart(String shoeId, int index) {
    shoeAdded.add(shoeId);
    setState(() {
      buttonIcons[index] = Icons.check;
    });
    print(shoeAdded);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppConstantsColor.white,
      body: SizedBox(
        width: width,
        height: height * 1.1,
        child: Stack(children: [
          Container(
            width: 150,
            height: height / 4.2,
            decoration: const BoxDecoration(
              color: AppConstantsColor.yello,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.elliptical(200, 230),
                topRight: Radius.elliptical(10, 60),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ImageIcon(
                      AssetImage('assets/images/nike.png'),
                      size: 48,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartPage()),
                        );
                      },
                      child: const Icon(
                        Icons.shopping_bag, // Sử dụng biểu tượng tích hợp sẵn
                        color:
                            AppConstantsColor.black, // Màu sắc của biểu tượng
                        size: 28, // Kích thước của biểu tượng
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Our Products',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: width,
                  height: height * 0.71,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shoes.length,
                    itemBuilder: (context, index) {
                      final shoe = shoes[index];
                      Color color = Color(
                          int.parse(shoe.color.substring(1), radix: 16) +
                              0xFF000000);
                      Cart cart = Cart(
                          id: shoe.id,
                          image: shoe.image,
                          name: shoe.name,
                          color: shoe.color,
                          price: shoe.price,
                          quantity: 1);
                      return SizedBox(
                        width: width,
                        height: height * 0.6,
                        child: ListView(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  width: 370,
                                  height: height / 2.15,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: RotationTransition(
                                    turns:
                                        const AlwaysStoppedAnimation(-25 / 360),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 32),
                                      child: Image.network(
                                        shoe.image,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    shoe.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 370,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showFullDescription =
                                              !showFullDescription;
                                        });
                                      },
                                      child: Text(
                                        showFullDescription
                                            ? shoe.description
                                            : '${shoe.description.substring(0, 162)}... See More',
                                        style: const TextStyle(fontSize: 12),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 60, 0),
                              child: SizedBox(
                                width: 370,
                                height: 56,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            AppConstantsColor.yello),
                                  ),
                                  onPressed: () {
                                    addToCart(shoe.id.toString(), index);
                                    final cartBloc = context.read<CartBloc>();
                                    cartBloc.add(AddToCart(cart));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("SHOE ADDED"),
                                      duration: Duration(seconds: 2),
                                    ));
                                  },
                                  child: buttonIcons.length > index &&
                                          buttonIcons[index] != null
                                      ? Icon(
                                          buttonIcons[index],
                                          color: Colors.black,
                                        )
                                      : const Text(
                                          'ADD TO CART',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
