import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:products_app/models/models.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';



class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if( productsService.isLoading ) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        //boton para LogOut
        actions: [
          IconButton(
            onPressed: () {
              
              authService.logout();
              Navigator.pushReplacementNamed(context, 'Login');

            }, 
            icon: const Icon ( Icons.login_outlined )
          )
        ],
      ),

      //Listview builder crea widgets cuando se esta cerca de abrir la pantalla.
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: ( BuildContext context, int index ) => GestureDetector(
          onTap: () {
            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed( context, 'Product');
          },
          child: ProductCard( 
            products: productsService.products[index], 
          ),
        ),
      ),


      //Boton para crear un nuevo producto.
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add ),
        onPressed: () {
          
          productsService.selectedProduct = Product(
            available: false, 
            name: '', 
            price: 0
          );
          Navigator.pushNamed(context, 'Product');
        },
      ),

      
    );
  }
}