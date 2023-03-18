import 'package:flutter/material.dart';


import 'package:products_app/models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.products});

  final Product products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 20 ),

      child: Container(
      margin: const EdgeInsets.only( top:30, bottom: 50),
      width: double.infinity,
      height: 400,
      decoration: _cardBorders(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [

          //Imagen de fondo
          _BackgroundImage( products.picture),

          //Detalles del producto
          _ProductDetails(
            titulo: products.name,
            subtitulo: products.id!,
          ),

          //Precio del producto
          Positioned(
            top: 0,
            right: 0,
            child: _PriceTag( products.price )
          ),

          //Mostrar disponibilidad
          if ( !products.available )
          Positioned(
            top: 0,
            left: 0,
            child: _NotAvailable()
          ),

        ],
      ),
      
      ),
    );
  }

  //Método de diseño de tarjeta
  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10,
      )
    ]
  );
}

//Mostrar disponibilidad en el producto.
class _NotAvailable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,

      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: const BorderRadius.only( topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),

      child: const FittedBox(
        fit: BoxFit.contain,

        child: Padding(
          padding: EdgeInsets.symmetric( horizontal: 10 ),

          child: Text(
            'No disponible',
            style: TextStyle( color: Colors.white, fontSize: 20),
          ),
        ), 
      ),
    );
  }
}

//Mostrar tarjeta con precio de producto
class _PriceTag extends StatelessWidget {

  final double price;

  const _PriceTag( this.price );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,

      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only( topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      ),

      child: FittedBox(
        fit: BoxFit.contain,

        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 10 ),
          child: Text('\$$price', style: const TextStyle( color: Colors.white, fontSize: 20))
        ),
      ),
    );
  }
}

//Mostrar detalle de productos
class _ProductDetails extends StatelessWidget {

  final String titulo;
  final String subtitulo;

  const _ProductDetails({ required this.titulo, required this.subtitulo });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only( right: 50 ),

      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
          width: double.infinity,
          height: 70,
          decoration: _buildBoxDecoration(),

          child: Column(
            //alinear columna de forma horizontal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Texto superior(titulo)
               Text(titulo, 
               style: const TextStyle( fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold ),
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
              ),

              //Texto inferior(subtitulo)
              Text(subtitulo, 
               style: const TextStyle( fontSize: 15, color: Colors.white ),
              ),
            ]
            
          ),
       ),
    );
  }

  //Método de productdetails
  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only( bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
  );
}

//widget privado: BackGroundImage
class _BackgroundImage extends StatelessWidget {

  final String? url;

  const _BackgroundImage( this.url );

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),

      child: Container(
          width: double.infinity,
          height: 400,
          child: url == null
          ? const Image(
            image: AssetImage('assets/no-image.png'), fit: BoxFit.cover)
          : FadeInImage(
            placeholder: const AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(url!),
            fit: BoxFit.cover,
          ),
          
          

       ),

    );
  }
}