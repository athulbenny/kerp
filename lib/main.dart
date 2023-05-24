import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kerp/register.dart';
import 'login.dart';

String ip="<IP or LINK>:80 or 443";


// @override
// void initState() {
//   Timer.periodic(const Duration(milliseconds: 10000), (timer) {
//      main();
//     });
// }

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) =>
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.green),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
    initialRoute: "login",
    routes: {
      'login': (cxt) => Login(),
      'register':(cxt)=>Register(),
    },
    )
  )
  );
}
