import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:pangan_marketplace/keranjanglistBloc.dart';
import 'package:pangan_marketplace/pangan_item.dart';
import 'package:intl/intl.dart';

class Items extends StatelessWidget {
  Items({
    required this.leftAligned,
    required this.imgUrl,
    required this.itemName,
    required this.itemPrice,
    required this.per,
  });
  final bool leftAligned;
  final String imgUrl;
  final String itemName;
  final double itemPrice;
  final String per;
  @override
  Widget build(BuildContext context) {
    double containerPadding = 45;
    double containerBorderRadius = 10;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: leftAligned ? 0 : containerPadding,
            right: leftAligned ? containerPadding : 0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: leftAligned
                        ? Radius.circular(0)
                        : Radius.circular(containerBorderRadius),
                    right: leftAligned
                        ? Radius.circular(containerBorderRadius)
                        : Radius.circular(0),
                  ),
                  child: Image.asset(
                    imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.only(
                    left: leftAligned ? 20 : 0,
                    right: leftAligned ? 0 : 20,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(itemName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      fontFamily: 'jaapokkienchance')),
                            ),
                            Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp',
                                        decimalDigits: 0)
                                    .format(itemPrice),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  fontFamily: 'jaapokkienchance',
                                )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontFamily: 'jaapokkienchance'),
                                children: [
                                  TextSpan(
                                      text: "Per. ",
                                      style: TextStyle(
                                        fontFamily: 'jaapokkienchance',
                                      )),
                                  TextSpan(
                                      text: per,
                                      style: TextStyle(
                                          fontFamily: 'jaapokkienchance',
                                          fontWeight: FontWeight.w700))
                                ]),
                          ),
                        ),
                        SizedBox(height: containerPadding),
                      ])),
            ],
          ),
        )
      ],
    );
  }
}

class ItemContainer extends StatelessWidget {
  ItemContainer({
    required this.panganItem,
  });
  final PanganItem panganItem;
  final KeranjangListBloc bloc = BlocProvider.getBloc<KeranjangListBloc>();
  addToKeranjang(PanganItem panganItem) {
    bloc.addToList(panganItem);
  }

  removeFromList(PanganItem panganItem) {
    bloc.removeFromList(panganItem);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addToKeranjang(panganItem);
        final snackBar = SnackBar(
          content: Text(
            "${panganItem.title} berhasil di tambah dikeranjang",
            style: TextStyle(fontFamily: 'jaapokkienchance'),
          ),
          duration: Duration(milliseconds: 550),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Items(
        per: panganItem.per,
        itemName: panganItem.title,
        itemPrice: panganItem.price,
        imgUrl: panganItem.imgUrl,
        leftAligned: (panganItem.id % 2) == 0 ? true : false,
      ),
    );
  }
}
