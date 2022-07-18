import 'package:flutter/material.dart';
import 'package:pangan_marketplace/home.dart';
import 'package:pangan_marketplace/themeColor.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:pangan_marketplace/pangan_item.dart';
import 'package:intl/intl.dart';
import 'package:pangan_marketplace/keranjanglistBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:pangan_marketplace/drag.dart';
import 'package:pangan_marketplace/profile.dart';
import 'package:pangan_marketplace/keranjang.dart';

class BottomBar extends StatelessWidget {
  final List<PanganItem> panganItems;
  BottomBar(this.panganItems);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          totalHarga(panganItems),
          Divider(
            height: 1,
            color: Colors.grey[700],
          ),
          ButtonBarBayar(context),
        ],
      ),
    );
  }

  Container totalHarga(List<PanganItem> panganItems) {
    var ConvertToIDR =
        new NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Total:",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                fontFamily: 'jaapokkienchance'),
          ),
          Text(
            ConvertToIDR.format(int.parse(returnTotalHarga(panganItems))),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                fontFamily: 'jaapokkienchance'),
          ),
        ],
      ),
    );
  }

  String returnTotalHarga(List<PanganItem> panganItems) {
    double totalAmount = 0.0;

    for (int i = 0; i < panganItems.length; i++) {
      totalAmount =
          totalAmount + panganItems[i].price * panganItems[i].quantity;
    }
    return totalAmount
        .toStringAsFixed(totalAmount.truncateToDouble() == totalAmount ? 0 : 1);
  }

  Container ButtonBarBayar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Themes.color, borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Mulai Pesan",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  fontFamily: 'jaapokkienchance'),
            ),
          ],
        ),
        onTap: () {
          if (int.parse(returnTotalHarga(panganItems)) > 0) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              title: 'Berhasil',
              text: 'Pesanan berhasil diorder',
              confirmBtnText: 'Done',
              onConfirmBtnTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              },
            );
          } else {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title: 'Keranjang Kosong',
              text: 'Mohon masukan barang untuk memulai pesanan',
              confirmBtnText: 'Done',
              onConfirmBtnTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final KeranjangListBloc bloc = BlocProvider.getBloc<KeranjangListBloc>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            child: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        DragTargetWidget(bloc),
      ],
    );
  }
}

class CustomAppBar1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final KeranjangListBloc bloc = BlocProvider.getBloc<KeranjangListBloc>();
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: bloc.listStream,
              builder: (context, snapshot) {
                List<PanganItem>? panganItems =
                    snapshot.data as List<PanganItem>?;
                int length = panganItems != null ? panganItems.length : 0;

                return buildGestureDetector(length, context, panganItems!);
              },
            )
          ],
        ));
  }

  GestureDetector buildGestureDetector(
      int length, BuildContext context, List<PanganItem> panganItems) {
    return GestureDetector(
      onTap: () {
        if (length > 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Keranjang()));
        } else {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 30),
        child: Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black87,
              ),
              onPressed: () {
                if (length > 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Keranjang()));
                } else {
                  return;
                }
              },
            ),
            Positioned(
              top: 0,
              right: 6,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Themes.color,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  length.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.apply(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
