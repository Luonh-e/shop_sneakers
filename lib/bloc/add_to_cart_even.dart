import 'package:equatable/equatable.dart';
import 'package:sneakers_shop/model/cart_model.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Cart cart;
  AddToCart(this.cart);

  @override
  List<Object> get props => [cart];
}

class RemoveFromCart extends CartEvent {
  final cart;

  RemoveFromCart(this.cart);
  @override
  List<Object> get props => [cart];
}

class IncreaseQuantity extends CartEvent {
  final Cart cart;

  IncreaseQuantity(this.cart);
}

class DecreaseQuantity extends CartEvent {
  final Cart cart;

  DecreaseQuantity(this.cart);
}
