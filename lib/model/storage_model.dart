
import 'package:storage_stock_task/model/item_model.dart';



class StorageModel {
  String storageName;
  List<ItemModel> items;

  StorageModel(this.storageName, this.items);

  StorageModel.fromJson(Map<String, dynamic> json) {
    storageName = json['storageName'];
    if (json['items'] != null) {
      items = <ItemModel>[];
      json['items'].forEach((v) {
        items.add(ItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storageName'] = this.storageName;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

