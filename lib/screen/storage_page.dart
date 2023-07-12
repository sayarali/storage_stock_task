import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_stock_task/model/ItemModel.dart';
import 'package:storage_stock_task/model/storage_model.dart';

class StoragePage extends StatefulWidget {
  @override
  _StoragePageState createState() => _StoragePageState();
}



ItemModel parol = ItemModel("12374372", "Parol 50mg", DateTime.now(), 50);
ItemModel brufen = ItemModel("12374372", "Brufen 50mg", DateTime.now(), 30);
ItemModel majezik = ItemModel("12374372", "Majezik 50mg", DateTime.now(), 33);
ItemModel nexium = ItemModel("12374372", "Nexium 50mg", DateTime.now(), 65);
ItemModel rennie = ItemModel("12374372", "Rennie 50mg", DateTime.now(), 24);
List<ItemModel> acilIlacItems = <ItemModel>[parol, brufen, majezik, nexium, rennie];
StorageModel acilIlacDepo = StorageModel("Acil İlaç Deposu", acilIlacItems);


ItemModel sogan = ItemModel("12374372", "Soğan", DateTime.now(), 19);
ItemModel patates = ItemModel("12374372", "Patates", DateTime.now(), 27);
ItemModel biber = ItemModel("12374372", "Biber", DateTime.now(), 46);
ItemModel domates = ItemModel("12374372", "Domates", DateTime.now(), 24);
List<ItemModel> mutfakItems = <ItemModel>[sogan, patates, biber, domates];
StorageModel mutfakDepo = StorageModel("Mutfak", mutfakItems);


List<StorageModel> storageList = <StorageModel>[acilIlacDepo, mutfakDepo];

class _StoragePageState extends State<StoragePage>{




  StorageModel dropdownValue = storageList.first;


  Widget _dropDownMenu() {
    return Center(
      child: DropdownButton<StorageModel>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        menuMaxHeight: 300,
        isExpanded: true,
        elevation: 16,
        itemHeight: 70.0,
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (StorageModel value) {
          setState(() {
            dropdownValue = value;
          });
        },
        borderRadius: BorderRadius.circular(15.0),
        items: storageList.map<DropdownMenuItem<StorageModel>>((StorageModel value) {
          return DropdownMenuItem<StorageModel>(
            value: value,
            child: Text(value.storageName),
            onTap: (){
              print(value.storageName);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Depo Yönetimi", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300
        ),),

      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0
                    ),
                    child: Column(
                      children: <Widget>[
                        _dropDownMenu()


                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

}