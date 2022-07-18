import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pangan_marketplace/keranjanglistBloc.dart';
import 'package:pangan_marketplace/custombar.dart';
import 'package:pangan_marketplace/pangan_item.dart';
import 'package:intl/intl.dart';
import 'package:pangan_marketplace/drag.dart';

class Keranjang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final KeranjangListBloc bloc = BlocProvider.getBloc<KeranjangListBloc>();
    List<PanganItem>? panganItems;
    return StreamBuilder(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          panganItems = snapshot.data as List<PanganItem>?;
          return Scaffold(
            body: SafeArea(
              child: KeranjangBody(panganItems!),
            ),
            bottomNavigationBar: BottomBar(panganItems!),
          );
        } else {
          return Container(
            child: Text(
              "Kerajang anda kosong",
              style: TextStyle(
                fontFamily: 'jaapokkienchance',
              ),
            ),
          );
        }
      },
    );
  }
}

class KeranjangBody extends StatelessWidget {
  final List<PanganItem> panganItems;
  KeranjangBody(this.panganItems);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(35, 40, 25, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          title(),
          Expanded(
            flex: 1,
            child:
                panganItems.length > 0 ? panganItemList() : noItemContainer(),
          )
        ],
      ),
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text(
          "Keranjang Anda Kosong",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20,
              fontFamily: 'jaapokkienchance'),
        ),
      ),
    );
  }

  ListView panganItemList() {
    return ListView.builder(
      itemCount: panganItems.length,
      itemBuilder: (context, index) {
        return KeranjangListItem(panganItem: panganItems[index]);
      },
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Daftar",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                  fontFamily: 'jaapokkienchance',
                ),
              ),
              Text(
                "Pesanan Anda",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                  fontFamily: 'jaapokkienchance',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class KeranjangListItem extends StatelessWidget {
  final PanganItem panganItem;
  KeranjangListItem({Key? key, required this.panganItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      hapticFeedbackOnStart: false,
      maxSimultaneousDrags: 1,
      data: panganItem,
      feedback: DraggableChildFeedback(panganItem: panganItem),
      child: DraggableChild(panganItem: panganItem),
      childWhenDragging: panganItem.quantity > 1
          ? DraggableChild(panganItem: panganItem)
          : Container(),
    );
  }
}

class ItemContent extends StatelessWidget {
  const ItemContent({
    Key? key,
    required this.panganItem,
  }) : super(key: key);
  final PanganItem panganItem;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              panganItem.imgUrl,
              fit: BoxFit.fitHeight,
              height: 55,
              width: 80,
            ),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'jaapokkienchance'),
                children: [
                  TextSpan(text: panganItem.quantity.toString()),
                  TextSpan(
                      text: " x ",
                      style: TextStyle(
                        fontFamily: 'jaapokkienchance',
                      )),
                  TextSpan(
                    text: panganItem.title,
                  ),
                ]),
          ),
          Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
                .format(panganItem.quantity * panganItem.price),
            style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
                fontFamily: 'jaapokkienchance'),
          ),
        ],
      ),
    );
  }
}
