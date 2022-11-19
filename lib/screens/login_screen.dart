import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/registration_screen.dart';
import 'package:shopping/screens/user/user_home_screen.dart';

import '../helper/Constant.dart';
import 'manufacture/manufacturer_home_screen.dart';


class LoginScreen extends StatelessWidget {
  final _state=_LoginScreenState();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = Constant.getWidth(context);
    double height = Constant.getHeight(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return _state;
      },
      child:Scaffold(
        backgroundColor: Constant.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
           systemOverlayStyle: const SystemUiOverlayStyle(
               statusBarColor: Colors.blue,
           ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,left: 0,
              child: Container(
                width: width,
                height: height*0.35,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40.0),bottomRight: Radius.circular(40.0))
                ),
              ),
            ),
            Positioned(top:20,right:0,left:0,child: Center(child: Text("Shopping",style:TextStyle(fontSize: 25,color: Constant.white,fontWeight: FontWeight.bold)))),
            Positioned(
              // height: height*0.6,
              top: 30,
              right: 0,left: 0,
              child:  Container(
                // height: height*0.8,
                margin: const EdgeInsets.only(left: 20.0,right:20.0,top:30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Constant.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(blurRadius: 5,offset: Offset(0,2),color: Colors.black54)
                    ]
                ),
                child:   Form(
                  key: _state.formState,
                  child: Column(
                    children: [
                      Text("Login",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),),
                      // Align(alignment: Alignment.centerLeft,child: Text("    Email",style: TextStyle(fontWeight: FontWeight.bold,),),),
                      const SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) => _state.email = newValue.toString().trim(),
                        validator: (email){
                          if(!email!.contains("@")){
                            return "Please enter correct email";
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: Constant.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            // labelText: "Email",
                            hintText: "Enter your email here",
                            prefixIcon: const Icon(Icons.email_outlined),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)
                            )),
                      ),
                      const SizedBox(height: 20,),
                      //Align(alignment: Alignment.centerLeft,child: Text("    Password",style: TextStyle(fontWeight: FontWeight.bold,color:Constant.white)),),
                      // const SizedBox(height: 15,),
                      Consumer<_LoginScreenState>(
                        builder: (BuildContext context,state,Widget? child){
                          return TextFormField(
                            obscureText: _state.isObscure,
                            onSaved: (newValue) => _state.password = newValue.toString().trim(),
                            validator: (password){
                              if(password!.length<6){
                                return "Password length must greater then 6";
                              }
                            },
                            decoration: InputDecoration(
                                fillColor: Constant.white,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                // labelText: "Password",
                                hintText: "Enter your password...",
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(onPressed: (){
                                  Provider.of<_LoginScreenState>(context,listen: false).showHidePassword();
                                }, icon: Icon(state.isObscure? Icons.visibility : Icons.visibility_off)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.blue)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.blue)
                                )),
                          );
                        },
                      ),
                      const SizedBox(height: 20,),
                      Text("Select User Type"),
                      Consumer<_LoginScreenState>(
                        builder: (context,state,widget){
                          return Row(
                            children: [
                              Flexible(
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text("User",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
                                    value: _state.userType=="user"? true:false,
                                    onChanged: (value){
                                      _state.userType="user";
                                      Provider.of<_LoginScreenState>(context,listen: false).updateCheckBox();
                                    }),
                              ),
                              Flexible(
                                flex: 2,
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.all(5),
                                    title: const Text("Manufacturer",style: TextStyle(fontSize: 14),),
                                    value: _state.userType=="manufacturer"? true:false,
                                    onChanged: (value){
                                      _state.userType="manufacturer";
                                      Provider.of<_LoginScreenState>(context,listen: false).updateCheckBox();
                                    }),
                              ),
                            ],
                          );
                        }
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //       onPressed: () {
                      //         // Navigator.pushNamed(context, '/forgot');
                      //       },
                      //       child: Text(
                      //         "Forgot Password?",
                      //         style: TextStyle(color: Constant.black),
                      //       )
                      //   ),
                      // ),
                      const SizedBox(height: 5,),
                      TextButton(
                          onPressed: (){
                            _state.signIn(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:MaterialStateProperty.all(Colors.blue),
                              fixedSize: MaterialStateProperty.all(Size(width, height*0.07)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Constant.white),
                          )
                      ),
                      const SizedBox(height: 5,),
                      Row(children: [
                        const Text("Don't have account?"),
                        TextButton(onPressed: (){
                          var route = MaterialPageRoute(builder: (context) {
                              return RegistrationScreen();
                          });
                          Navigator.push(context, route);
                        }, child: const Text("register now"))
                      ],)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _LoginScreenState with ChangeNotifier{
  bool isObscure = true;
  String email="";
  String password="";
  String userType="";

  final formState=GlobalKey<FormState>();

  void updateCheckBox(){
    print(userType);
    notifyListeners();
  }

  void showHidePassword(){
    isObscure? isObscure=false:isObscure=true;
    notifyListeners();
  }

  void signIn(context) async {
    if (formState.currentState!.validate()) {
      formState.currentState!.save();
      //fetch user status
      if(userType.isNotEmpty){
        login(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select User Type")));
      }

    }
  }

  void login(context){
    var auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: email, password: password)
        .then((credential){
      var user=credential.user;
      if(user!=null) {
        if (user.displayName != userType) {
          FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your account is not registered as $userType type ")));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select correct login type ")));
        }else{
          showDialog(
              context: context, barrierDismissible: false, builder: (context) {
            return AlertDialog(
              title: const Text("Please wait"),
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator()
                  ]
              ),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Successfully")));
          var route = MaterialPageRoute(builder: (context) {
            if(userType=="user"){
              return UserHomeScreen();
            }else{
              return ManufacturerHomeScreen();
            }

          });
          Navigator.pushAndRemoveUntil(context, route,(route)=> false);
        }
      }
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    });
  }

}