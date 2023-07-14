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
  ItemModel("12374372", "Majezik Duo 100mg/8mg film kaplı tablet", DateTime.now(), 0, "https://i2.gazetevatan.com/i/gazetevatan/75/1200x0/618701d745d2a06698464a8c.jpg"),
  ItemModel("12374372", "Nexium 40mg enterik kaplı pellet tablet", DateTime.now(), 65, ""),
  ItemModel("12374372", "Rennie 680mg 48 çiğneme tableti", DateTime.now(), 0, ""),
];
StorageModel acilIlacDepo = StorageModel("Acil İlaç Deposu", acilIlacItems);


List<ItemModel> mutfakItems = <ItemModel>[
  ItemModel("12374372", "Soğan", DateTime.now(), 19, "https://w7.pngwing.com/pngs/298/360/png-transparent-onion-onion-vegetables-onion-clipart.png"),
  ItemModel("12374372", "Patates", DateTime.now(), 27, ""),
  ItemModel("12374372", "Biber", DateTime.now(), 46, ""),
  ItemModel("12374372", "Domates", DateTime.now(), 24, ""),
  ItemModel("8697419970035", "Kalabak Su 0,5 Litre", DateTime.now(), 24, ""),
  ItemModel("86935241", "Sigara", DateTime.now(), 13, "")
];
StorageModel mutfakDepo = StorageModel("Mutfak", mutfakItems);


List<StorageModel> storageList = <StorageModel>[acilIlacDepo, mutfakDepo];




class _StoragePageState extends State<StoragePage>{




  static StorageModel dropdownValue = storageList.first;
  static StorageModel updateDropdownMenu = dropdownValue;

  List<ItemModel> filteredList = dropdownValue.items;

  List<ItemModel> stockOutList= <ItemModel>[];
  List<ItemModel> stockList = <ItemModel>[];

  @override
  void initState() {
    filteredList = dropdownValue.items;
    filteredListSeperate(filteredList);
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
            filteredListSeperate(filteredList);
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
          border: const UnderlineInputBorder(),
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

  int toUpdateInt = 0;

  Widget _stockItemsListView(List<ItemModel> itemList) {
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
            loadingBuilder: (context, child, loadingProgress) {
              if(loadingProgress == null) {
                return child;
              }

              return CircularProgressIndicator(
                value: (loadingProgress != null)
                    ? (loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes)
                    : 0,
              );
            },
          ),
          title: Text(itemList[index].itemName),
          trailing: Text("Stok: ${itemList[index].itemCount}"),
          onTap: () {
            updateController.text = itemList[index].itemCount.toString();
            toUpdateInt = itemList[index].itemCount;
            updateDropdownMenu = dropdownValue;
            _itemAlertDialog(itemList[index]);
            setState(() {

            });
          },
        );
      },
    );
  }
  Widget _stockOutItemsListView(List<ItemModel> itemList) {
    if(itemList.isNotEmpty){
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Stoğu biten ürünler",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
          ListView.builder(
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
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null) {
                      return child;
                    }

                    return CircularProgressIndicator(
                      value: (loadingProgress != null)
                          ? (loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes)
                          : 0,
                    );
                  },
                ),
                title: Text(itemList[index].itemName),
                trailing: Text("Stokta yok"),
                onTap: () {
                  updateController.text = itemList[index].itemCount.toString();
                  toUpdateInt = itemList[index].itemCount;
                  updateDropdownMenu = dropdownValue;
                  _itemAlertDialog(itemList[index]);
                  setState(() {

                  });
                },
              );
            },
          ),
        ],
      );
    }
    else {
      return const SizedBox();
    }

  }


  Future<void> _deleteAlertDialog(ItemModel itemModel) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Evet'),
              onPressed: () {
                deleteItem(itemModel);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {

                });
              },
            ),
          ],
        );
      }
    );
  }

  Future<void> _itemAlertDialog(ItemModel itemModel) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            scrollable: true,
            title: Image.network(
              itemModel.itemImage,
              width: 50,
              height: 50,
              errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                return const ImageIcon(
                  AssetImage("assets/no-photo.png"),
                  size: 50,

                );
              },
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      itemModel.itemName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text("Son kullanma tarihi: "
                        "${itemModel.itemExpiredDate.day}"
                        "/${itemModel.itemExpiredDate.month}"
                        "/${itemModel.itemExpiredDate.year}",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text("Stok adedi: ${itemModel.itemCount}"),
                  ),
                  const SizedBox(height: 15.0,),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Stok Güncelle",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,

                      ),
                    ),
                  ),
                  _updateStockWidget(itemModel),
                  const SizedBox(height: 25.0,),
                  _updateItemStorage(itemModel)

                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  _deleteAlertDialog(itemModel);
                },
                label: const Text('Ürünü Sil'),
              ),
              TextButton(
                child: const Text('İptal'),
                onPressed: () {
                  filteredListSeperate(filteredList);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  if(updateController.text != ""){
                    try {
                      setState(() {
                        if(int.parse(updateController.text) < 0){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Stok sayısı negatif olamaz!"),)
                          );
                        }
                        else {
                          itemModel.itemCount = int.parse(updateController.text);
                          filteredListSeperate(filteredList);
                          Navigator.of(context).pop();
                        }

                      });
                      setState(() {

                      });
                    } catch(e) {
                      print(e);
                    }

                  }
                },
              ),
            ],
          ),
        );
      }
    );
  }


  Widget _updateStockWidget(ItemModel itemModel) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: TextButton(
              onPressed: () {
                updateController.text = (toUpdateInt -= 5).toString();
              },
              child: const Text("-5"),
            ),
          ),
          SizedBox(
            width: 50,
            child: TextButton(
              onPressed: () {
                updateController.text = (toUpdateInt -= 1).toString();
              },
              child: const Text("-1"),
            ),
          ),
          SizedBox(
            width: 40,
            child: TextField(
              controller: updateController,
              decoration: const InputDecoration(
                hintText: "5",
              ),
              textAlign: TextAlign.center,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: TextButton(
              onPressed: () {
                updateController.text = (toUpdateInt += 1).toString();
              },
              child: const Text("+1"),
            ),
          ),
          SizedBox(
            width: 50,
            child: TextButton(
              onPressed: () {
                updateController.text = (toUpdateInt += 5).toString();

              },
              child: const Text("+5"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _updateItemStorage(ItemModel itemModel) {
    return SizedBox(
      child: Row(
        children: [
          const Text("Depoyu değiştir:   "),
          SizedBox(
            width: 135,
            child: _updateStorageDropdown(itemModel),
          )
        ],
      )
    );
  }

  Widget _updateStorageDropdown(ItemModel itemModel){

    return DropdownButton<StorageModel>(
      value: updateDropdownMenu,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      elevation: 16,
      style: const TextStyle(color: Colors.blueAccent),
      menuMaxHeight: 300,
      isExpanded: true,
      itemHeight: 50.0,
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (StorageModel value) {
        print("onChanged:${value.storageName}");
        updateDropdownMenu = value;
        updateDropdownMenu.items.add(itemModel);
        dropdownValue.items.remove(itemModel);
        filteredList = dropdownValue.items;
        setState(() {

        });

      },
      items: storageList.map<DropdownMenuItem<StorageModel>>((StorageModel value) {
        return DropdownMenuItem<StorageModel>(
          value: value,
          child: Text(value.storageName),
          onTap: () {
            print("items:${value.storageName}");
            setState(() {
              updateDropdownMenu = value;
            });
          },
        );
      }).toList(),
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
                        _stockItemsListView(stockList),
                        const SizedBox(height: 25.0,),

                        _stockOutItemsListView(stockOutList)

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
              .contains(searchText.toLowerCase()) || element.itemBarcode
              .contains(searchText)
      ).toList();
      filteredListSeperate(filteredList);
    });
  }


  void filteredListSeperate(List<ItemModel> toFilterList) {
    setState(() {
      stockOutList = toFilterList.where((element) => element.itemCount == 0).toList();
      stockList = toFilterList.where((element) => element.itemCount != 0).toList();
    });
  }

  void deleteItem(ItemModel itemModel){
    setState(() {
      for(int i = 0; i<storageList.length; i++){
        storageList[i].items.remove(itemModel);
      }
      filteredListSeperate(filteredList);
    });
  }
}