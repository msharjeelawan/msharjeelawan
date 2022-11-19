import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/screens/login_screen.dart';
import 'package:shopping/screens/manufacture/manufacturer_home_screen.dart';
import 'package:shopping/screens/user/user_home_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    splashToOther(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.white
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset("assets/images/logo.png"),
         // child: Text("Shopping",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }

  splashToOther(context){
    Future.delayed(const Duration(milliseconds: 2000),() async{
      var user = FirebaseAuth.instance.currentUser;
      var route;
      if(user!=null){
        route = MaterialPageRoute(builder: (context) {
          if(user.displayName=="user"){
            return UserHomeScreen();
          }else{
            return ManufacturerHomeScreen();
          }
        });

      }else{
        route = MaterialPageRoute(builder: (context) {
            return LoginScreen();
        });
      }
      Navigator.pushReplacement(context, route);
    });
  }
}
