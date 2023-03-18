import 'package:flutter/material.dart';

class NotificationsService {

  //mantiene la referencia al material app
  static late GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar( String message ){

    final snackBar = SnackBar(
      // content: Text(message, style: const TextStyle( color: Colors.white, fontSize: 20) ),
      content: AlertDialog(
          elevation: 5,
          backgroundColor: Colors.white,
          title: const Text('Error', style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold),),
          shape: RoundedRectangleBorder( borderRadius: BorderRadiusDirectional.circular(10) ),
          content: Column(
            //Controlar tamaño de columna
            mainAxisSize: MainAxisSize.min,

            children: const [

              Text('El correo electrónico ingresado NO es válido.(Desliza hacía abajo o espera 4 segundos)', 
              style: TextStyle( fontSize: 18 ),
              ),

              SizedBox( height: 20),

            ],

          ),
        )
    );

    messengerKey.currentState!.showSnackBar(snackBar);

  }

}
