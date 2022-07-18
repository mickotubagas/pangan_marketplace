import 'package:flutter/material.dart';
import 'package:pangan_marketplace/keranjang.dart';
import 'package:pangan_marketplace/listTileColorBloc.dart';
import 'package:pangan_marketplace/pangan_item.dart';
import 'package:pangan_marketplace/keranjanglistBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';

class DraggableChild extends StatelessWidget {
  const DraggableChild({
    Key? key,
    required this.panganItem,
  }) : super(key: key);
  final PanganItem panganItem;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(
        panganItem: panganItem,
      ),
    );
  }
}

class DraggableChildFeedback extends StatelessWidget {
  const DraggableChildFeedback({
    Key? key,
    required this.panganItem,
  }) : super(key: key);
  final PanganItem panganItem;
  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();
    return Opacity(
      opacity: 0.7,
      child: Material(
        child: StreamBuilder(
          stream: colorBloc.colorStream,
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.red,
                //color: snapshot.data != null ? snapshot.data : Colors.white,
              ),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.95,
              child: ItemContent(panganItem: panganItem),
            );
          },
        ),
      ),
    );
  }
}

class DragTargetWidget extends StatefulWidget {
  final KeranjangListBloc bloc;

  DragTargetWidget(this.bloc);

  @override
  _DragTargetWidgetState createState() => _DragTargetWidgetState();
}

class _DragTargetWidgetState extends State<DragTargetWidget> {
  @override
  Widget build(BuildContext context) {
    PanganItem currentPanganItem;
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return DragTarget<PanganItem>(
      onAccept: (PanganItem panganItem) {
        currentPanganItem = panganItem;
        colorBloc.setColor(Colors.white);
        widget.bloc.removeFromList(currentPanganItem);
      },
      onWillAccept: (panganItem) {
        colorBloc.setColor(Colors.red);
        return true;
      },
      onLeave: (panganItem) {
        colorBloc.setColor(Colors.white);
      },
      builder: (BuildContext context, List incoming, List rejected) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            CupertinoIcons.delete,
            size: 35,
          ),
        );
      },
    );
  }
}
