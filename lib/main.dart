import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';


void main() => runApp(AppState());

//Se crea la clase para que en toda la app se tenga acceso al ProductsServices.
class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => ProductsService() )
      ],
      child: const MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //Quitar el banner de debug
      debugShowCheckedModeBanner: false,

      title: 'Productos App',

      initialRoute: 'Home',

      //Rutas de pantallas a mostrar en la aplicación.
      routes: {
        'Login' : ( _ ) => const LoginScreen(),
        'Home' : ( _ ) => const HomeScreen(),
        'Product' : ( _ ) => ProductScreen(),
      },

      //Cambiar globalmente el tema de los scaffold, appbar, FloatinActionButton
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],

        //Diseño appbar
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),

        //Diseño floaitngactionbutton
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
      ),
    );
  }
}