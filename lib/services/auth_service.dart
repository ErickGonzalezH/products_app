import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;



class AuthService extends ChangeNotifier{

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  //Token de acceso al API Farebase
  final String _firebaseToken = 'AIzaSyBrgJVadtqmk4TW2z_LakTqVHcixFfaajc';
  final storage = FlutterSecureStorage();



  //Método de SignUp o Crear usuario
  //Si retornamos algo es un error, si no, todo bien
  Future<String?> createUser( String email, String password ) async {

    //Crear la informacion del post
    final Map<String, dynamic> authData = {
      'email': email, 
      'password': password,
      'returnSecureToken' : true
    };

    //Crear peticion
    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    //disparar peticion
    final resp = await http.post(url, body: json.encode( authData ));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('idToken') ) {
      //Token hay que guardar en un lugar seguro
      await storage.write(key:'token', value: decodedResp['idToken']);
      
      return null;

    } else {
      return decodedResp['error']['message'];
    }

  }

  //Metodo de Login o SingIn
  Future<String?> login( String email, String password ) async {

    //Crear la informacion del post
    final Map<String, dynamic> authData = {
      'email': email, 
      'password': password,
      'returnSecureToken' : true
    };

    //Crear peticion
    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    //disparar peticion
    final resp = await http.post(url, body: json.encode( authData ));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('idToken') ) {
      //Token hay que guardar en un lugar seguro
      await storage.write(key:'token', value: decodedResp['idToken']);
      return null;

    } else {
      return decodedResp['error']['message'];
    }

  }

  //LogOut
  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  //verificar si se tiene un token
  Future<String> readToken() async{

    return await storage.read(key:'token') ?? '';
    
  }



  
}