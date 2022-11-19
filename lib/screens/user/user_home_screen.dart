import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/models/product_model.dart';

import '../../helper/Constant.dart';
import 'chat_screen.dart';
import '../login_screen.dart';


class UserHomeScreen extends StatelessWidget {
  final _state=UserListState();
  UserHomeScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = Constant.getWidth(context);
    double height = Constant.getHeight(context);
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
              future: _state.getProducts(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }
                List<ProductModel> productList=snapshot.data as List<ProductModel>;
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10,childAspectRatio: 0.8),
                    itemCount: productList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    itemBuilder: (context,index){
                      return Container(
                        child: ListTile(
                          title: Text(productList[index].name),
                          subtitle: SizedBox(
                           // width: width*0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                productList[index].imageUrl.isEmpty?
                                Text("No Image")
                                    :
                                Image.network(productList[index].imageUrl,width: 80,height: 80,),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        var route = MaterialPageRoute(builder: (context) {
                                          return ChatScreen(receiverId: productList[index].ownerId,);
                                        });
                                        Navigator.push(context, route);
                                      },
                                      icon: Icon(Icons.chat),
                                    ),
                                    IconButton(
                                        onPressed: (){
                                          _state.buynow(context,index);
                                        },
                                        icon: Icon(Icons.shopping_cart)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: (){
                            // var route=MaterialPageRoute(builder: (context){
                            //   return ProfileOrOrderScreen(index: index,userType:userType);
                            // });
                            // Navigator.push(context, route);
                          },
                        ),
                        // subtitle: productList[index].imageUrl.isEmpty?
                        // Text("No Image")
                        //     :
                        // Image.network(productList[index].imageUrl,width: 100,height: 100,),
                        decoration: BoxDecoration(
                            color: Colors.white,
                           // image: DecorationImage(image: Image.network(productList[index].imageUrl,width: 100,height: 100,).image,),
                            boxShadow: const [
                              BoxShadow(blurRadius: 2,color: Colors.black38)
                            ],
                          border: const Border(bottom: BorderSide(color: Colors.black12))
                        ),
                      );
                    }
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


  void buynow(context,int index){
    var product=ProductModel.list[index];
    var userId=FirebaseAuth.instance.currentUser?.uid;
    var order={"buyer_id":userId,"product_id":product.id,"owner_id":product.ownerId};
    FirebaseDatabase.instance.ref("orders").push().update(order).then((value){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(product.name +" successfully buy")));
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    });
  }

}
