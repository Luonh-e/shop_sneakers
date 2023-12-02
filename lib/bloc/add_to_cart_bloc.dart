import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneakers_shop/bloc/add_to_cart_even.dart';
import 'package:sneakers_shop/bloc/add_to_cart_state.dart';
import 'package:sneakers_shop/model/cart_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState([])) {
    on<CartEvent>(_mapEvenToState);
  }

  Future<void> _mapEvenToState(CartEvent event, Emitter<CartState> emit) async {
    if (event is AddToCart) {
      final updatedCart = List<Cart>.from(state.cartItems)..add(event.cart);
      emit(CartState(updatedCart));
    } else if (event is RemoveFromCart) {
      final updatedCart = List<Cart>.from(state.cartItems)..remove(event.cart);
      emit(CartState(updatedCart));
    }
  }
}
