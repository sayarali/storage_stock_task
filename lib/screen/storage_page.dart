import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_stock_task/model/ItemModel.dart';
import 'package:storage_stock_task/model/storage_model.dart';


import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class StoragePage extends StatefulWidget {
  @override
  _StoragePageState createState() => _StoragePageState();
}


List<ItemModel> acilIlacItems = <ItemModel>[
  ItemModel("12374372", "Parol 500mg tablet", DateTime.now(), 48, "https://www.haberlerdunya.com.tr/wp-content/uploads/2023/04/parol-agri-kesici-1024x562.webp"),
  ItemModel("12374372", "Brufen 400mg tablet", DateTime.now(), 30, "https://cdn.hekimce.com/uploads/2022/basliksiz-1-1671678078.jpg"),
  ItemModel("12374372", "Majezik Duo 100mg/8mg film kaplı tablet", DateTime.now(), 33, "https://i2.gazetevatan.com/i/gazetevatan/75/1200x0/618701d745d2a06698464a8c.jpg"),
  ItemModel("12374372", "Nexium 40mg enterik kaplı pellet tablet", DateTime.now(), 65, ""),
  ItemModel("12374372", "Rennie 680mg 48 çiğneme tableti", DateTime.now(), 24, "")
];
StorageModel acilIlacDepo = StorageModel("Acil İlaç Deposu", acilIlacItems);


List<ItemModel> mutfakItems = <ItemModel>[
  ItemModel("12374372", "Soğan", DateTime.now(), 19, "https://w7.pngwing.com/pngs/298/360/png-transparent-onion-onion-vegetables-onion-clipart.png"),
  ItemModel("12374372", "Patates", DateTime.now(), 27, ""),
  ItemModel("12374372", "Biber", DateTime.now(), 46, ""),
  ItemModel("12374372", "Domates", DateTime.now(), 24, ""),
  ItemModel("8697419970035", "Kalabak Su 0,5 Litre", DateTime.now(), 24, "")
];
StorageModel mutfakDepo = StorageModel("Mutfak", mutfakItems);


List<StorageModel> storageList = <StorageModel>[acilIlacDepo, mutfakDepo];




class _StoragePageState extends State<StoragePage>{

  bool fromBarcode = false;



  static StorageModel dropdownValue = storageList.first;
  List<ItemModel> filteredList = dropdownValue.items;
  @override
  void initState() {
    super.initState();
  }

  final searchController = TextEditingController();
  final updateController = TextEditingController();

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
            filteredList = value.items;
          });
        },
        borderRadius: BorderRadius.circular(15.0),
        items: storageList.map<DropdownMenuItem<StorageModel>>((StorageModel value) {
          return DropdownMenuItem<StorageModel>(
            value: value,
            child: Text(value.storageName),
            onTap: (){

            },
          );
        }).toList(),
      ),
    );
  }
  Widget _searchTextField() {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextField(
        onChanged: (value) => filterItemList(dropdownValue.items, value),
        controller: searchController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "Depoda ürün ara",
          helperText: "Ürün ismi ya da barkod numarası",
          prefixIcon: const Icon(
            Icons.search_rounded
          ),
          suffixIcon: IconButton(
            icon: const ImageIcon(
              AssetImage('assets/barcode.png'),
              size: 28,
            ),
            onPressed: () async {
              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666",
                "İptal",
                true,
                ScanMode.BARCODE
              );
              searchController.text = barcodeScanRes;
              filterItemList(dropdownValue.items, barcodeScanRes);
              setState(() {
              });
            },
          ),
        ),
      ),
    );
  }


  Widget _itemsListView(List<ItemModel> itemList) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            itemList[index].itemImage,
            width: 50,
            height: 50,
            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              return const ImageIcon(
                AssetImage("assets/no-photo.png"),
                size: 50,

              );
            },
          ),
          title: Text(itemList[index].itemName),
          trailing: Text("Stok: ${itemList[index].itemCount}"),
          onTap: () {
            updateController.text = "";
            _itemAlertDialog(itemList[index]);
          },
        );
      },
    );
  }


  Future<void> _itemAlertDialog(ItemModel itemModel) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(itemModel.itemName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text("Son kullanma tarihi: ${itemModel.itemExpiredDate}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text("Stok adedi: ${itemModel.itemCount}"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: updateController,
                  decoration: const InputDecoration(
                    hintText: "Stok güncelle"
                  ),
                )

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                if(updateController.text != ""){
                  try {
                    setState(() {
                      itemModel.itemCount = int.parse(updateController.text);
                      Navigator.of(context).pop();
                    });
                  } catch(e) {
                    print(e);
                  }

                }
              },
            ),
          ],
        );
      }
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
                SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0
                    ),
                    child: Column(
                      children: <Widget>[
                        _dropDownMenu(),
                        const SizedBox(height: 15.0,),
                        _searchTextField(),
                        const SizedBox(height: 25.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Ürünler",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                            Text(
                              "Toplam: ${filteredList.length.toString()}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,

                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15.0,),
                        _itemsListView(filteredList)

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






  void filterItemList(List<ItemModel> toFilterList, String searchText){
    setState(() {
      filteredList = toFilterList.where(
              (element) => element.itemName.toLowerCase()
              .contains(searchText.toLowerCase()) || element.itemBarcode.toLowerCase()
              .contains(searchText.toLowerCase())
      ).toList();
    });
  }

}