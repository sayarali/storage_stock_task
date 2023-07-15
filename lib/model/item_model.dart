class ItemModel{
  String itemBarcode;
  String itemName;
  DateTime itemExpiredDate;
  int itemCount;
  String itemImage;

  ItemModel(this.itemBarcode, this.itemName, this.itemExpiredDate, this.itemCount, this.itemImage);

  ItemModel.fromJson(Map<String, dynamic> json)
      : itemBarcode =  json['itemBarcode'],
        itemName = json['itemName'],
        itemExpiredDate = json['itemExpiredDate'],
        itemCount = json['itemCount'],
        itemImage = json['itemImage'];

  Map<String, dynamic> toJson() =>
      {
        'itemBarcode': itemBarcode,
        'itemName': itemName,
        'itemExpiredDate': itemExpiredDate,
        'itemCount': itemCount,
        'itemImage': itemImage,
      };
}

class Items {
  String itemName;
  String itemBarcode;
  int itemExpiredTime;
  int itemCount;
  String itemImage;

  Items(
      {this.itemName,
        this.itemBarcode,
        this.itemExpiredTime,
        this.itemCount,
        this.itemImage});

  Items.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemBarcode = json['itemBarcode'];
    itemExpiredTime = json['itemExpiredTime'];
    itemCount = json['itemCount'];
    itemImage = json['itemImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['itemBarcode'] = this.itemBarcode;
    data['itemExpiredTime'] = this.itemExpiredTime;
    data['itemCount'] = this.itemCount;
    data['itemImage'] = this.itemImage;
    return data;
  }
}
