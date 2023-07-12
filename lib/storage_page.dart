


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoragePage extends StatefulWidget {

  @override
  _StoragePageState createState() => _StoragePageState();

}


class _StoragePageState extends State<StoragePage>{


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
                        vertical: 80.0
                    ),
                    child: Column(
                      children: const <Widget>[


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