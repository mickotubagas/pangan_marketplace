import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:pangan_marketplace/keranjanglistBloc.dart';
import 'package:pangan_marketplace/listTileColorBloc.dart';
import 'package:pangan_marketplace/pangan_item.dart';
import 'package:pangan_marketplace/custombar.dart';
import 'package:pangan_marketplace/item.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        //add yours BLoCs controlles
        Bloc((i) => KeranjangListBloc()),
        Bloc((i) => ColorBloc()),
      ],
      dependencies: [],
      child: Scaffold(
        body: SafeArea(
            child: Container(
          child: ListView(
            children: <Widget>[
              AwalanPage(),
              SizedBox(height: 45),
              for (var panganItem in panganitemList.panganItems)
                Builder(
                  builder: (context) {
                    return ItemContainer(panganItem: panganItem);
                  },
                )
            ],
          ),
        )),
      ),
    );
  }
}

class AwalanPage extends StatelessWidget {
  const AwalanPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomAppBar1(),
            SizedBox(height: 30),
            title(),
            SizedBox(height: 30),
            searchBar(),
          ],
        ),
      ),
    );
  }
}

Widget searchBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Icon(
        Icons.search,
        color: Colors.black45,
      ),
      SizedBox(width: 20),
      Expanded(
        child: TextField(
          decoration: InputDecoration(
              hintText: "Pencarian....",
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintStyle: TextStyle(
                color: Colors.black87,
                fontFamily: 'jaapokkienchance',
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red))),
        ),
      ),
    ],
  );
}

Widget title() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(width: 45),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Selamat Datang",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                fontFamily: 'jaapokkienchance',
              ),
            ),
            Text(
              "Sedia Panganan",
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 30,
                fontFamily: 'jaapokkienchance',
              ),
            ),
          ],
        ),
      )
    ],
  );
}
