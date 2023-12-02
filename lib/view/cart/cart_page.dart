import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneakers_shop/bloc/add_to_cart_bloc.dart';
import 'package:sneakers_shop/bloc/add_to_cart_even.dart';
import 'package:sneakers_shop/bloc/add_to_cart_state.dart';
import 'package:sneakers_shop/utils/constants.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
          BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty!'));
            } else {
              double totalPrice = 0;
              for (int i = 0; i < state.cartItems.length; i++) {
                totalPrice +=
                    state.cartItems[i].price * state.cartItems[i].quantity;
              }
              String totalPriceString = totalPrice.toStringAsFixed(2);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              ImageIcon(
                                AssetImage('assets/images/nike.png'),
                                size: 48,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text(
                                  'Your Cart',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: Text(
                                  '\$$totalPriceString',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width,
                      height: height * 0.71,
                      child: ListView.builder(
                          itemCount: state.cartItems.length,
                          itemBuilder: (context, index) {
                            String originalString = state.cartItems[index].name;
                            int maxLength = 20;

                            String part1 =
                                originalString.substring(0, maxLength);
                            String part2 = originalString.substring(maxLength);
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              width: width,
                              height: height / 5,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.32,
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 40, left: 10),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color(int.parse(
                                                      state.cartItems[index]
                                                          .color
                                                          .substring(1),
                                                      radix: 16) +
                                                  0xFF000000)),
                                        ),
                                        RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              -25 / 360),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Image.network(
                                              width: 120,
                                              height: 160,
                                              state.cartItems[index].image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 38),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  part1,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                if (originalString.length >
                                                    maxLength) // Hiển thị chỉ khi có phần thứ 2
                                                  Text(
                                                    part2,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              '\$${state.cartItems[index].price}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (state.cartItems[index]
                                                          .quantity >
                                                      1) {
                                                    setState(() {
                                                      state.cartItems[index]
                                                          .quantity--;
                                                    });
                                                  } else {
                                                    final cartBloc =
                                                        BlocProvider.of<
                                                            CartBloc>(context);
                                                    cartBloc.add(RemoveFromCart(
                                                        state
                                                            .cartItems[index]));
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: Colors
                                                              .grey.shade300),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'assets/images/minus.png'),
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Text(
                                                        state.cartItems[index]
                                                            .quantity
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          state.cartItems[index]
                                                              .quantity++;
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            color: Colors
                                                                .grey.shade300),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: ImageIcon(
                                                            AssetImage(
                                                                'assets/images/plus.png'),
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              final cartBloc =
                                                  BlocProvider.of<CartBloc>(
                                                      context);
                                              cartBloc.add(RemoveFromCart(
                                                  state.cartItems[index]));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 70),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: AppConstantsColor.yello,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: ImageIcon(
                                                  AssetImage(
                                                      'assets/images/trash.png'),
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            }
          })
        ]),
      ),
    ));
  }
}
