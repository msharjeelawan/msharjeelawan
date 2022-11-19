import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/Constant.dart';

class AddProductScreen extends StatefulWidget {
  final _state=_addProductState();
  AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    double width = Constant.getWidth(context);
    double height = Constant.getHeight(context);
    return Scaffold(
      backgroundColor: Constant.white,
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: widget._state.formKey,
            child: Column(
              children:  [
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter a Valid name";
                    }
                  },
                  onSaved: (newValue) => widget._state.name = newValue.toString().trim(),
                  decoration: InputDecoration(
                    //icon: CircleAvatar(backgroundColor: Constant.leftCircleOnProfileScreen,),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    hintText: "Product Name",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Constant.primaryColor)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Constant.primaryColor)
                    ),
                  ),

                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onSaved: (newValue) => widget._state.description = newValue.toString().trim(),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter a Valid Description";
                    }
                  },
                  decoration: InputDecoration(
                  //  icon: CircleAvatar(backgroundColor: Constant.leftCircleOnProfileScreen,),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Constant.primaryColor)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Constant.primaryColor)
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  //  expands: true,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter a Valid price";
                    }
                  },
                  onSaved: (newValue) => widget._state.price = newValue.toString().trim(),
                  decoration: InputDecoration(

                    contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  //  icon: CircleAvatar(backgroundColor: Constant.leftCircleOnProfileScreen,),
                    hintText: "Price",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Constant.primaryColor)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Constant.primaryColor)
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    widget._state.xfile==null?
                    SizedBox(width:width*0.7,height:150)
                        :
                    Image.file(File(widget._state.xfile!.path,),width:width*0.7,height:150,),
                    IconButton(
                        onPressed: (){
                          widget._state.showPicker(context,this);
                          },
                        icon: Icon(Icons.add)
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                TextButton(
                    onPressed: (){
                      widget._state.addProduct(context,this);
                      setState(() {

                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:MaterialStateProperty.all(Constant.primaryColor),
                        fixedSize: MaterialStateProperty.all(Size(width*0.75, height*0.07)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
                    ),
                    child:  Text(
                      "Add Product",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Constant.white),
                    )
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _addProductState{
  final formKey = GlobalKey<FormState>();
  String name="",description="",price="";
  XFile? xfile;
  void addProduct(context,_AddProductScreenState state){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();

      DatabaseReference ref = FirebaseDatabase.instance.ref("products");
      var pushed = ref.push();
      var manufacturerId=FirebaseAuth.instance.currentUser?.uid;
      pushed.update({"owner_id":manufacturerId,"name":name,"description":description,"price":price}).then((value) async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product Added.")));
        formKey.currentState?.reset();
        if(xfile!=null){
          File image = File(xfile!.path);

          var imageName=manufacturerId!+DateTime.now().millisecond.toString();
          //upload image in firebase storage and add image url in fb db
          TaskSnapshot snapshot = await FirebaseStorage.instance.ref("productImages").child(imageName).putFile(image);
          String imgPath = await snapshot.ref.getDownloadURL();
          FirebaseDatabase.instance.ref("products").child(pushed.key!).update({"imageUrl":imgPath}).then((value) {
           // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Uploaded Successfully")));
            xfile=null;
            state.setState(() {

            });
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image is not selected")));
        }
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      });

    }
  }

  void showPicker(context,state) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      pickImage(ImageSource.gallery,context,state);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera,context,state);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Future<void> pickImage(source,context,_AddProductScreenState state) async {
    // print("pick file");
    final picker=ImagePicker();
     xfile = await  picker.pickImage(source: source);
     if(xfile!=null){
       state.setState(() {

       });
     }
  }
}
