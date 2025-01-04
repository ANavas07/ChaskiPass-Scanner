import 'package:flutter/material.dart';
import 'package:passengercontrol_chaskipass/blocs/errorPopup.blocs.dart';
import 'package:passengercontrol_chaskipass/components/inputDecoration.components.dart';
import 'package:passengercontrol_chaskipass/components/passwordField.components.dart';
import 'package:passengercontrol_chaskipass/models/loginRequest.models.dart';
import 'package:passengercontrol_chaskipass/screens/auth/helpers/auth.helpers.dart';
import 'package:passengercontrol_chaskipass/screens/home/principalView.home.dart';
import 'package:passengercontrol_chaskipass/screens/home/scanner.home.dart';
import 'package:passengercontrol_chaskipass/services/authService.services.dart';
// import 'package:passengercontrol_chaskipass/src/blocs/errorPopup.blocs.dart';

//StateFulWidget es un widget que puede cambiar su estado
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //Widdet que contiene a los demas widgets
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,

        //Stack es un conjunto de widgets, [contiene el diseño parte superior]
        child: Stack(
          children: [
            //Contenedor para el fondo de color azul
            purpleBox(size),
            //Contenedor para el icono
            iconToShow(),
            //Para agregar un conjunto de widgets
            //Quiero tener un widget arriba de otro para eso usaremos column
            paramsForm(),
          ],
        ),
      ),
    );
  }

  //Formulario de inicio de sesion
  SingleChildScrollView paramsForm() {
    /*Scroll para cuando salga el teclado mi area del formulario se mueva para poder
    escribir*/
    return SingleChildScrollView(
      child: Column(
        //aqui agrego todos los widgets que voy a necesitar
        children: [
          /*Este permite mover el contenedor a diferentes posiciones de la pantalla
                parecido a mover con display = flex
                */
          const SizedBox(height: 250),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            //height: 350, solo era para ver como se forma el contenedor
            //Para suavizar los bordes o border radius
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),

            //Otra lista de widgets para que el texto se vea mejor
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Ingreso",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                //Espacio adicional
                const SizedBox(height: 30),
                //Para crear el formulario
                // ignore: avoid_unnecessary_containers
                Container(
                  //Widget form siver para validar los datos que estamos ingresando
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          //evitar autocorreciones
                          autocorrect: false,
                          controller: _userNameController,
                          decoration: MineInputDecorations.ownInputDecoration(
                            hintText: "Usuario",
                            labelText: "Usuario",
                            iconI: const Icon(Icons.account_circle),
                          ),
                        ),

                        //Widget nuevo
                        const SizedBox(height: 30),
                        TextFormField(
                          //evitar autocorreciones
                          autocorrect: false,
                          controller: _emailController,
                          decoration: MineInputDecorations.ownInputDecoration(
                            hintText: "Email",
                            labelText: "Email",
                            iconI: const Icon(Icons.mail),
                          ),
                        ),

                        //Widget nuevo
                        const SizedBox(height: 30),

                        PasswordTextField(controller: _passwordController),

                        const SizedBox(height: 30),

                        //Widget para el boton
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledColor: Colors.grey,
                          color: const Color.fromARGB(255, 78, 129, 67),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 80,
                              vertical: 20,
                            ),
                            child: const Text(
                              "Ingresar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            validateUser(
                              _userNameController.text,
                              _passwordController.text,
                            );
                            clearInputs();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void validateUser(String username, String password) async {
    if (username == '' || password == '') {
      //ver bien por que no funciona correctamente

      DialogUtils.showErrorDialog(context, "Datos incorrectos");
      return;
    } else {
      try {
        AuthService actionService = AuthService();
        String result = await actionService.logIn(
          LoginRequest(
            username: username,
            email: _emailController.text,
            password: password,
          ),
        );

        if (result != "") {
          navigateToNextScreen(context); //no funciona
        } else {
          DialogUtils.showErrorDialog(context, 'Credenciales incorrectas');
        }
      } catch (e) {
        DialogUtils.showErrorDialog(context, e.toString());
      }
    }
  }

  void clearInputs() {
    _userNameController.clear();
    _passwordController.clear();
    _emailController.clear();
  }

  void navigateToNextScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => Principalview()));
  }
}
