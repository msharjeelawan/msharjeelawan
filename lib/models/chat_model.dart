
class ChatModel{
  String _id="";
  String _msg="";
  String _time="";

  static List<ChatModel> _list=[];

  ChatModel(this._id,this._msg,this._time);

  static List<ChatModel> fromJsonToModel(String key,Map<dynamic,dynamic> map){
    var chatModel=ChatModel(map['id'].toString(), map['msg'], map['time']);
    _list.add(chatModel);
    return _list;
  }

  static List<ChatModel> get list => _list;

  String get time => _time;

  String get msg => _msg;

  String get id => _id;
}