import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/cart/cart.dart';
import 'package:flutter_application_1/features/home/bloc/home_bloc.dart';
import 'package:flutter_application_1/features/home/product_tile_widget.dart';
import 'package:flutter_application_1/features/wishlist/wishlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    homebloc.add(HomeInitialEvent());
    super.initState();
  }

  final HomeBloc homebloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homebloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        } else if (state is HomeNavigateToWishlistPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wishlist()));
        }
        else if (state is HomeProductItemWishlistedActionState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Item Wishlisted')));
        }
        else if (state is HomeProductItemCartedActionState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Item Carted')));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
            break;
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            return Scaffold(
              appBar: AppBar(
                  title: Text('Satoshi Grocery App'),
                  backgroundColor: Colors.teal,
                  actions: [
                    IconButton(
                        onPressed: () {
                          homebloc.add(HomeWishlistButtonNavigateEvent());
                        },
                        icon: Icon(Icons.favorite_border)),
                    IconButton(
                        onPressed: () {
                          homebloc.add(HomeCartButtonNavigateEvent());
                        },
                        icon: Icon(Icons.shopping_bag_outlined))
                  ]),
                  body: ListView.builder(itemCount: successState.products.length, itemBuilder: (context,index){  
                    return ProductTileWidget(productDataModel:successState.products[index], homeBloc: homebloc,);
                  }),
            );
            break;

          case HomeErrorState:
            return Scaffold(body:Center(child:Text('Error')));
            break;
          default:
          return SizedBox();
        }
      },
    );
  }
}
