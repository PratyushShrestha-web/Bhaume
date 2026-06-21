import 'package:flutter/material.dart';
import'pages/home.dart';
void main(){
  runApp  (const MyApp()); //the engine of the app
}

class MyApp extends StatelessWidget {// statelesswidget means it is static, it doesnt need to change time to time
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
       debugShowCheckedModeBanner: false,
       home: Homepage()



   );
  }
}