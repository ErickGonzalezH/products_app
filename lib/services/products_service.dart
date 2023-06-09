//Se encarga de hacer peticiones http
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:products_app/models/models.dart';



class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-aa4d0-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  Product? selectedProduct;

  final storage = const FlutterSecureStorage();

  //Almacenar imagen
  File? newPictureFile;

  //Propiedad para saber cuando se esta cargando o no 
  bool isLoading = true;
  bool isSaving = false;

  ProductsService() { loadProducts(); }

  //Hacer fetch de productos(peticion http)
  Future<List<Product>> loadProducts() async{

    //hacer estado de loading
    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'products.json', {
      'auth' : await storage.read(key:'token') ?? ''
    });

    final resp = await http.get( url );


    final Map<String, dynamic> productsMap = json.decode( resp.body );

    productsMap.forEach((key, value) {
      
      final tempProduct = Product.fromJson( value );
      tempProduct.id = key;
      products.add( tempProduct );

    });

    //Deshacer estado de loading
    isLoading = false;
    notifyListeners();

    return products;
  }

  //Guardar o crear un producto
  Future saveOrCreateProduct( Product product) async {
    isSaving = true;
    notifyListeners();

    if( product.id == null) {

      //es necesario crear
      await createProduct( product );

    } else {

      //Actualizar
      await updateProduct( product );

    }


    isSaving = false;
    notifyListeners();
  }

  //Actualizar un producto
  Future<String> updateProduct( Product product) async {

    final url = Uri.https( _baseUrl, 'products/${ product.id }.json', {
      'auth' : await storage.read(key:'token') ?? ''
    });

    final resp = await http.put( url, body: json.encode(product.toJson()) );
    final decodeData = resp.body;

    //Actualizar el listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
    
  }

  //Crar producto
  Future<String> createProduct( Product product) async {

    final url = Uri.https( _baseUrl, 'products.json', {
      'auth' : await storage.read(key:'token') ?? ''
    });
    
    final resp = await http.post( url, body: json.encode(product.toJson()) );
    final decodeData = json.decode( resp.body );

    product.id = decodeData['name'];

    products.add(product);

    return product.id!;
    
    
  }


  //Actualizar imagen del producto
  void updateSelectedProductImage( String path) {

    selectedProduct?.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();

  }

  //Cargar imagen a cloudinary
  Future<String?> uploadImage() async{

    //Se asegura de que se tenga una imagen
    if ( newPictureFile == null ) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dnya8lxuu/image/upload?upload_preset=aeyokjdv');

    //Crear la peticion
    final imageUpleadRequest = http.MultipartRequest( 'POST', url );

    //Adjuntar el file
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );

    //Unir la peticion con el file
    imageUpleadRequest.files.add(file);

    //disparar la peticion
    final streamResponse = await imageUpleadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 200){
      print('mal');
      print( resp.body );
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];

  }

}