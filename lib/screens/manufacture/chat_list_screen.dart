import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/chat_list_model.dart';
import 'manufacturer_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final _state=ChatListState();
  ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  @override
  void initState() {
    super.initState();
    widget._state.getChatList(this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
      ),
      body: SafeArea(
        child: ChatListModel.list.isEmpty?
        const Center(child: CircularProgressIndicator())
        :
        ListView.builder(
            itemCount: ChatListModel.list.length,
            itemBuilder: (context,index){
              return Container(
                child: ListTile(
                  title: Text(ChatListModel.list[index].name),
                  onTap: (){
                    var route=MaterialPageRoute(builder: (context){
                      return ManufacturerChatScreen(chatId: ChatListModel.list[index].id,);
                    });
                    Navigator.push(context, route);
                  },
                ),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))
                ),
              );
            }
        )

      ),
    );
  }
}



class ChatListState{
  var manufacturerId=FirebaseAuth.instance.currentUser?.uid;
  Future<List<ChatListModel>> getChatList(_ChatListScreenState state) async {
    var list=<ChatListModel>[];
    await FirebaseDatabase.instance.ref("chats").once().then((event) async {
      var snapshot = event.snapshot;
      //print(snapshot.value);
      if(snapshot.value!=null){
        Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
        list= await ChatListModel.fromJsonToModel(map,manufacturerId!);
        return list;
      }
    })
     .catchError((e){
      print(e);
    });
    getUserName(state);
    return list;
  }


  void getUserName(_ChatListScreenState state) async {

    for (var chatModel in ChatListModel.list) {
      print("user fetching");
      var userId=chatModel.id.split("_")[0];
     await FirebaseDatabase.instance.ref("users").orderByKey().equalTo(userId).once().then((event){
        var snapshot = event.snapshot;
        print(snapshot.value);
        if(snapshot.value!=null){
          Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
          map.forEach((key, v) {
            chatModel.name= v['fullName'];
            //print()
          });
        }
      });
     state.setState(() {

     });
    }
  }

}
