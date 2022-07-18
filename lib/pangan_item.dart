import 'package:flutter/foundation.dart';

PanganitemList panganitemList = PanganitemList(panganItems: [
  PanganItem(
    id: 1,
    title: "Beras Putih JP",
    per: "1 Kilogram",
    price: 14000,
    imgUrl: "images/beras.jpg",
  ),
  PanganItem(
    id: 2,
    title: "Kubis Hijau Segar",
    per: "1 - 1.5 Kilogram",
    price: 6000,
    imgUrl: "images/kubis.jpeg",
  ),
  PanganItem(
    id: 3,
    title: "Apel Merah Segar",
    per: "1 Kilogram",
    price: 41000,
    imgUrl: "images/apel.jpg",
  ),
  PanganItem(
    id: 4,
    title: "Roti Tawar",
    per: "12 Potongan",
    price: 19000,
    imgUrl: "images/roti.jpg",
  ),
  PanganItem(
    id: 5,
    title: "Starfruit Segar",
    per: "1 Kilogram",
    price: 30000,
    imgUrl: "images/buahbintang.jpg",
  ),
  PanganItem(
    id: 6,
    title: "Bayam Segar",
    per: "1 Bungkus Kemasan",
    price: 17000,
    imgUrl: "images/bayam.jpg",
  ),
]);

class PanganitemList {
  List<PanganItem> panganItems;
  PanganitemList({required this.panganItems});
}

class PanganItem {
  int id;
  String title;
  String per;
  double price;
  String imgUrl;
  int quantity;
  PanganItem({
    required this.id,
    required this.title,
    required this.per,
    required this.price,
    required this.imgUrl,
    this.quantity = 1,
  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}
