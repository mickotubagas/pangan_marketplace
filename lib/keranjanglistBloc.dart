import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:pangan_marketplace/providerBloc.dart';
import 'package:pangan_marketplace/pangan_item.dart';
import 'package:rxdart/rxdart.dart';

class KeranjangListBloc extends BlocBase {
  KeranjangListBloc();
  final BehaviorSubject<List<PanganItem>> _listController =
      BehaviorSubject<List<PanganItem>>.seeded([]);
  KeranjangProvider provider = KeranjangProvider();
  Stream<List<PanganItem>> get listStream => _listController.stream;
  Sink<List<PanganItem>> get listSink => _listController.sink;

  addToList(PanganItem panganItem) {
    listSink.add(provider.addToList(panganItem));
  }

  removeFromList(PanganItem panganItem) {
    listSink.add(provider.removeFromList(panganItem));
  }

  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}
