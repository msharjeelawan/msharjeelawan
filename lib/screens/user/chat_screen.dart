import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helper/Constant.dart';
import '../../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final _state=_ChatState();
  String receiverId;
  ChatScreen({Key? key,required this.receiverId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    widget._state.getChat(this,widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    var myId=FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.blue,
          ),
        ),
        body: widget._state.willLoad? const Center(child: CircularProgressIndicator(),)
            :
        Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: ChatModel.list.length,
                    itemBuilder: (context,index){
                      if(ChatModel.list[index].id==myId){
                        return Align(
                          alignment: Alignment.centerRight,
                          child: MyCard(msg:ChatModel.list[index].msg),
                        );
                      }
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: MyCard(msg:ChatModel.list[index].msg),
                      );
                    }
                    ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: widget._state.formState,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (newValue) => widget._state.msg = newValue.toString().trim(),
                        validator: (msg){
                          if(msg!.isEmpty){
                            return "Please enter msg";
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: Constant.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            // labelText: "Email",
                            hintText: "Enter your message here",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Constant.primaryColor)
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Constant.primaryColor)
                            )),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        widget._state.sendMsg(myId!, widget.receiverId,this);
                      },
                      icon: const Icon(Icons.send))
                ],
              )
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget._state.streamSubscription.cancel();
  }

}

class MyCard extends StatelessWidget {
  String msg;
  MyCard({Key? key,required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = Constant.getWidth(context);
    double height = Constant.getHeight(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: width*0.6,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text(msg),
    );
  }
}

class _ChatState{
  final formState=GlobalKey<FormState>();
  String msg="";
  bool willLoad=true;
  var list=<ChatModel>[];
  late StreamSubscription streamSubscription;

  void sendMsg(String sender,String receiver,_ChatScreenState state){
    if(formState.currentState!.validate()){
      formState.currentState!.save();
      String chatId = sender+"_"+receiver;
      FirebaseDatabase.instance.ref("chats").child(chatId).push()
          .update({"id":sender,"msg":msg,"time":"2121"}).then((value) {
            formState.currentState!.reset();
            // var modal = ChatModel(sender, msg, "2121");
            // ChatModel.list.add(modal);
            // state.setState(() {
            //
            // });
      }).catchError((e){
        ScaffoldMessenger.of(state.context).showSnackBar(
            SnackBar(content: Text(e.message)));
      });
    }
  }


  void getChat(_ChatScreenState state,String receiver) async {
    ChatModel.list.clear();
    var myId=FirebaseAuth.instance.currentUser?.uid;
    String chatId = myId!+"_"+receiver;
    streamSubscription = FirebaseDatabase.instance.ref("chats").child(chatId).onChildAdded.listen((event) {
      var snapshot = event.snapshot;
      var key = snapshot.key;
      print("result");
      print(snapshot.value);
      if(snapshot.value!=null){
        Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
        list=ChatModel.fromJsonToModel(key!,map);
        state.setState(() {

        });
      }
  });
    Future.delayed(Duration(seconds: 5),(){
      willLoad=false;
      state.setState(() {

      });
    });
  }


}
