import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/models/product_model.dart';
import 'package:shopping/screens/login_screen.dart';

import 'add_product_screen.dart';
import 'chat_list_screen.dart';

class ManufacturerHomeScreen extends StatefulWidget {
  final _state=UserListState();
  ManufacturerHomeScreen({Key? key}) : super(key: key);

  @override
  State<ManufacturerHomeScreen> createState() => _ManufacturerHomeScreenState();
}

class _ManufacturerHomeScreenState extends State<ManufacturerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var route = MaterialPageRoute(builder: (context){return ChatListScreen();});
                await Navigator.push(context, route);
                setState(() {

                });
              },
              icon: const Icon(Icons.chat)
          ),
          IconButton(
              onPressed: () async {
                var route = MaterialPageRoute(builder: (context){return AddProductScreen();});
                await Navigator.push(context, route);
                setState(() {

                });
              },
              icon: Icon(Icons.add)
          ),
          IconButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                var route = MaterialPageRoute(builder: (context){return LoginScreen();});
                Navigator.pushAndRemoveUntil(context, route,(route) => false);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logout Successfully")));
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: widget._state.getProducts(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }
                List<ProductModel> productList=snapshot.data as List<ProductModel>;
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
                    itemCount: productList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    itemBuilder: (context,index){
                      return Container(

                        child: ListTile(
                          title: Text(productList[index].name),
                          subtitle: productList[index].imageUrl.isEmpty?
                          Text("No Image")
                              :
                          Image.network(productList[index].imageUrl,width: 100,height: 100,),
                          onTap: (){
                            // var route=MaterialPageRoute(builder: (context){
                            //   return ProfileOrOrderScreen(index: index,userType:userType);
                            // });
                            // Navigator.push(context, route);
                          },
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(blurRadius: 2,color: Colors.black38)
                          ],
                            border: Border(bottom: BorderSide(color: Colors.black12))
                        ),
                      );
                    },
                );
              }
          )
      ),
    );
  }
}


class UserListState{

  Future<List<ProductModel>> getProducts() async {
     var list=<ProductModel>[];
    await FirebaseDatabase.instance.ref("products").once().then((event){
     var snapshot = event.snapshot;
     print(snapshot.value);
     if(snapshot.value!=null){
       Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
       list=ProductModel.fromJsonToModel(map);
       return list;
     }
    }).catchError((e){
      print(e);
    });
    return list;
  }

}
