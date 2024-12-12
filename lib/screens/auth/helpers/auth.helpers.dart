//Icono a usar
import 'package:flutter/material.dart';

SafeArea iconToShow() {
  return SafeArea(
    child: Container(
      //margen superior, margin es propiedad de container
      margin: const EdgeInsets.only(top: 60),
      width: double.infinity,
      //agrego el icono que es un widget y para agregar un widget uso un child
      child: const Icon(Icons.bus_alert_sharp, color: Colors.white, size: 100),
    ),
  );
}

//Contenedor para el fondo de color azul
Container purpleBox(Size size) {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromRGBO(15, 71, 224, 1), Color.fromRGBO(6, 47, 161, 1)],
      ),
      borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8.0,
          spreadRadius: 2.0,
          offset: const Offset(0, 4), // Sombra hacia abajo
        ),
      ],
    ),
    width: double.infinity,
    height: size.height * 0.4,
    child: Stack(
      children: [
        Positioned(top: 90, left: 30, child: buble()),
        Positioned(top: -40, left: -30, child: buble()),
        Positioned(top: 5, left: 190, child: buble()),
      ],
    ),
  );
}

//burbujas
Container buble() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: const Color.fromARGB(11, 159, 206, 177),
    ),
  );
}
