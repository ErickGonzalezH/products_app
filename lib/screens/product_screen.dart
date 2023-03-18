import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';



import 'package:products_app/providers/providers.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';



class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productServices = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider( productServices.selectedProduct! ),
      child: _ProductScreenBody( productServices: productServices ),
    );
  }
}

//Cuerpo del productScreen
class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productServices,
  }) : super(key: key);

  final ProductsService productServices;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        //Cuando se haga scroll se oculta el teclado
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [

            Stack(
              children: [
                ProductImage( url: productServices.selectedProduct!.picture ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    //Al presionar navegar al Home.
                    onPressed: () => Navigator.of(context).pop(), 
                    //Icono de regresar.
                    icon: const Icon( Icons.arrow_back_ios_new, size: 40, color: Colors.white )
                  )
                ),

                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    //Al presionar navegar a la camara.
                    onPressed: () async {

                      final ImagePicker _picker = ImagePicker();
                      final XFile? pickedFile = await _picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100 
                      );

                      if( pickedFile == null ) {
                        print('No seleccionó nada');
                        return;
                      }

                      productServices.updateSelectedProductImage(pickedFile.path);

                    }, 
                    //Icono de camara.
                    icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.white )
                  ),
                ),

                //Boton para la galeria
                Positioned(
                  top: 380,
                  right: 20,
                  child: IconButton(
                    //Al presionar navegar a la camara o galeria.
                    onPressed: () async {

                      final ImagePicker _picker = ImagePicker();
                      final XFile? pickedFile = await _picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 100 
                      );

                      if( pickedFile == null ) {
                        print('No seleccionó nada');
                        return;
                      }

                      productServices.updateSelectedProductImage(pickedFile.path);

                    }, 
                    //Icono de camara.
                    icon: const Icon( Icons.image_outlined, size: 40, color: Colors.white )
                  ),

                  
                )
              ],
            ),

            _ProductForm(),

            const SizedBox( height: 100 ),

          ],
        ),
      ),

      //Ubicacion del floatingactionbutton
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      //Boton flotante para guardar producto
      floatingActionButton: FloatingActionButton(
        onPressed: productServices.isSaving
        ? null
        : () async{

          if ( !productForm.isValidForm() ) return;

          //cargar el producto
          final String? imageUrl = await productServices.uploadImage();

          if ( imageUrl != null ) productForm.product.picture = imageUrl;

          await productServices.saveOrCreateProduct(productForm.product);

        },
        child: productServices.isSaving
        ? const CircularProgressIndicator( color: Colors.white )
        : const Icon( Icons.save_outlined),
      ),
    );
  }
}

//Widget de productForm
class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 10),

      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20 ),
        width: double.infinity,
        height: 280,
        decoration: _buldBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(

            children: [
              const SizedBox( height: 10 ),

              //Nombre del producto
              TextFormField(
                initialValue: product.name,
                onChanged: ( value ) => product.name = value,
                validator: ( value ) {
                  if ( value == null || value.length < 1 )
                  return'El nombre es obligatorio';
                },

                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:',
                  ),
              ),

              const SizedBox( height: 30 ),

              //Precio del producto
              TextFormField(
                initialValue: '${product.price}',

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],

                onChanged: (value) {
                  if ( double.tryParse(value) == null ){
                    product.price = 0;
                  } else {
                  product.price = double.parse(value);
                  }
                },

                //Deficinion de tipo de teclado para precio
                keyboardType: TextInputType.number,

                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ej. \$150', 
                  labelText: 'Precio:',
                  ),
              ),

              const SizedBox( height: 30 ),

              //Boton de disponibilidad de producto, colocar como IOS o Android.
              SwitchListTile(
                value: product.available, 
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productForm.updateAvailability
              ),

              const SizedBox( height: 30 ),
            ],
          ),
        ),
      ),

    );
  }

  //Método para decoracion de tarjeta del registro del producto
  BoxDecoration _buldBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    //Añadir sombra
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 5),
        blurRadius: 5
      )
    ]
     
  );
}
