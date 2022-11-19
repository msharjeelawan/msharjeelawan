

import 'package:firebase_database/firebase_database.dart';

class ChatListModel{
  String _id="";
  String _name="";

  static List<ChatListModel> list=[];

  ChatListModel(this._id);


  static List<ChatListModel> fromJsonToModel(Map<dynamic,dynamic> json,String manufactuerId){
    list.clear();
    json.forEach((k, v) async {
      var id = k.toString();
      int index = id.indexOf("_");
      if(id.contains(manufactuerId,index)){
        var chatListModal=ChatListModel(k);
        list.add(chatListModal);
      }
    });
    return list;
  }


  String get id => _id;

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}