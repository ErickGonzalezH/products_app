import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:products_app/providers/providers.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';



class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox( height: 220 ),

                CardContainer(
                  child: Column(
                    children: [

                      const SizedBox( height: 10 ),
                      Text('Ingresar', style: Theme.of(context).textTheme.headline4),
                      const SizedBox( height: 30 ),

                      ChangeNotifierProvider(
                        create: ( _ ) => LoginFromProvider(),
                        child: _LoginForm(),
                      ),

                    ],
                  )
                ),

                const SizedBox( height: 50 ),
                const Text('Crear una nueva cuenta', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ) ),
                const SizedBox( height: 50 ),
                

              ],
            ),
          ),
      ),
    );
  }
}

//Formulario o loginform
class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFromProvider>(context);


    return Container(
      child: Form(

        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [

            //Correo electronico.
            TextFormField(
              //Poner el autocorrector en falso
              autocorrect: false,
              //Habilitar el keyboard para correo electronico
              keyboardType: TextInputType.emailAddress,
              //diseño del input
              decoration: InputDecorations.authInputDecoration( 
                hintText: 'leo.gh@gmail.com', 
                labelText: 'Correo electrónico', 
                prefixIcon: Icons.alternate_email_rounded,
              ),

              onChanged: ( value ) => loginForm.email = value,

              //Validar si es un correo electrónico.
              validator: ( value ) {

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);

                return regExp.hasMatch( value ?? '' )
                  ? null 
                  : 'El valor ingresado NO es un correo electrónico.';
              },
            ),
            
            const SizedBox( height: 30 ),

            //Contraseña
            TextFormField(
              //Poner el autocorrector en falso
              autocorrect: false,
              //Ocultar el texo para contraseña
              obscureText: true,
              //diseño del input
              decoration: InputDecorations.authInputDecoration( 
                hintText: '********', 
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_rounded,
              ),
              
              onChanged: ( value ) => loginForm.password = value,
              //Validar si es contraseña
              validator: ( value ) {

                return ( value != null && value.length >= 6 )
                  ? null
                  : 'La contraseña tiene que tener un mínimo de 6 caracteres';
              },
            ),

            const SizedBox( height: 30 ),

            //Boton ingresar.
            MaterialButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,

              onPressed: loginForm.isLoading ? null : () async { 
                //Quitar el teclado 
                FocusScope.of(context).unfocus();

                if ( !loginForm.isValidForm() ) return;

                loginForm.isLoading = true;

                await Future.delayed( const Duration( seconds: 2 ) );
                
                //TODO: validar si el correo es correcto.
                loginForm.isLoading = false;

                Navigator.pushReplacementNamed(context, 'Home');
              },
              
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15 ),
                child: Text(
                  loginForm.isLoading
                   ? 'espere'
                   : 'Ingresar',
                  style: const TextStyle( color: Colors.white ),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}