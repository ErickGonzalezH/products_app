import 'package:flutter/material.dart';



class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      height: double.infinity,

      //El widget stack permite poner widgets encima de otros.
      child: Stack(
        children: [

          _PurpleBox(),

          //Icono superior
          _HeaderIcon(),

          child,
          

        ],
      ),
    );
  }
}

//Icono superior
class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: Container(

        width: double.infinity,
        margin: const EdgeInsets.only( top: 30 ),
        child: const Icon( Icons.person_pin, color: Colors.white, size: 100),

      ),

    );

  }
}


//Diseño parte superior
class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Container(

      width: double.infinity,

      //Se multiplica por 0.4 para obtener el 40% de la pantalla.
      height: size.height * 0.4,

      //Colocar el color gradiente horizontalmente
      decoration: _PurpleBackground(),

      //Circulos de fondo(positioned funciona solo dentro del stack)
      child: Stack(
        children: [

          Positioned(child: _Bubble(), top: 90, left: 30,),
          Positioned(child: _Bubble(), top: -40, left: -30,),
          Positioned(child: _Bubble(), top: -50, right: -20,),
          Positioned(child: _Bubble(), bottom: -50, left: 10,),
          Positioned(child: _Bubble(), bottom: 120, right: 20,),

        ],
      ),
    );
  }

  //purple background.
  BoxDecoration _PurpleBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ]
      )
    );
  }
}

//Circulos encima del fondo
class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}