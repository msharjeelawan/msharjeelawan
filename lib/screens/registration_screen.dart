import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/login_screen.dart';


import '../helper/Constant.dart';


class RegistrationScreen extends StatelessWidget {
  final _state=_RegisterScreenState();
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = Constant.getWidth(context);
    double height = Constant.getHeight(context);
    return ChangeNotifierProvider(
      create:(context) => _state,
      child: Scaffold(
        backgroundColor: Constant.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              // statusBarColor: Constant.primaryColor,
              // statusBarIconBrightness: Brightness.light
          ),
        ),
        body: Stack(
          //fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              right: 0,left: 0,
              child: Container(
                width: width,
                height: height*0.35,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40.0),bottomRight: Radius.circular(40.0))
                ),
              ),
            ),
            Positioned(top:20,right:0,left:0,child: Center(child: Text("Shopping",style:TextStyle(fontSize: 25,color: Constant.white,fontWeight: FontWeight.bold)))),
            // Image.asset("assets/images/logo.png",width: width*0.4,height: height*0.25,),
            Positioned(
              // height: height*0.6,
              top: 30,
              right: 0,left: 0,
              child:  Container(
                margin: const EdgeInsets.only(left: 20.0,right:20.0,top:30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Constant.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(blurRadius: 5,offset: Offset(0,2),color: Colors.black54)
                    ]
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Text("Registration",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),),
                    const SizedBox(height: 25,),
                    Form(
                      key: _state.formKey,
                      child: Column(
                        children: [
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
                          Consumer<_RegisterScreenState>(
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
                                      Provider.of<_RegisterScreenState>(context,listen: false).showHidePassword();
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
                          Consumer<_RegisterScreenState>(
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
                                            Provider.of<_RegisterScreenState>(context,listen: false).updateCheckBox();
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
                                            Provider.of<_RegisterScreenState>(context,listen: false).updateCheckBox();
                                          }),
                                    ),
                                  ],
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextButton(
                        onPressed: (){

                          _state.register(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:MaterialStateProperty.all(Colors.blue),
                            minimumSize: MaterialStateProperty.all(Size(width, height*0.07)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                        ),
                        child:  Text(
                          "Submit",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Constant.white),
                        )
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _RegisterScreenState with ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  bool isObscure = true;
  String email="";
  String password="";
  String fullName="";
  String userType="";

  void showHidePassword(){
    isObscure? isObscure=false:isObscure=true;
    notifyListeners();
  }

  void updateCheckBox(){
    print(userType);
    notifyListeners();
  }

  void register(context){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      if(userType.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select User Type")));
        return;
      }
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((userCredential) {
        var user = userCredential.user;
        if(user!=null){
          user.updateDisplayName(userType);
          FirebaseDatabase.instance.ref("users").child(user.uid).update({"email":email,"fullName":fullName});
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registered Successfully")));
          var route = MaterialPageRoute(builder: (context) {
            return LoginScreen();
          });
          Navigator.pushReplacement(context, route);
        }
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      });
    }
  }

}