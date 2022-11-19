
class ProductModel{
  String _id="";
  String _name="";
  String _description="";
  String _price="";
  String _imageUrl="";
  String _ownerId="";

  static List<ProductModel> list=[];

  ProductModel(this._id,this._name,this._description,this._price,this._imageUrl,this._ownerId);

  static List<ProductModel> fromJsonToModel(Map<dynamic,dynamic> json){
    list.clear();
    json.forEach((k, v) {
        var productModal=ProductModel(k,v["name"], v["description"], v["price"],v["imageUrl"],v["owner_id"]);
        list.add(productModal);
    });
    return list;
  }


  String get id => _id;

  String get price => _price;

  String get description => _description;

  String get name => _name;

  String get imageUrl => _imageUrl;

  String get ownerId => _ownerId;
}