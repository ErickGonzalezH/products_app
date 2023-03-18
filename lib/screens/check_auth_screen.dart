import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';



class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

            if( !snapshot.hasData )
            return Text('');

            if ( snapshot.data == '') {
              Future.microtask(() {

                //Transicion de pantalla.
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: ( _, __, ___ ) => const LoginScreen(),
                    transitionDuration: const Duration( seconds: 0)
                  )
                );

              });

            } else {
              Future.microtask(() {

                //Transicion de pantalla.
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: ( _, __, ___ ) => const HomeScreen(),
                    transitionDuration: const Duration( seconds: 0)
                  )
                );

              });
            }

            return Container();
          }
        ),
      ),
    );
  }
}