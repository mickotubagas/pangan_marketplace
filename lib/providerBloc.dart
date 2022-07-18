import 'package:pangan_marketplace/pangan_item.dart';

class KeranjangProvider {
  List<PanganItem> panganItems = [];
  List<PanganItem> addToList(PanganItem panganItem) {
    bool isPresent = false;

    if (panganItems.isNotEmpty) {
      for (int i = 0; i < panganItems.length; i++) {
        if (panganItems[i].id == panganItem.id) {
          increaseItemQuantity(panganItem);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }
      if (!isPresent) {
        panganItems.add(panganItem);
      }
    } else {
      panganItems.add(panganItem);
    }
    return panganItems;
  }

  List<PanganItem> removeFromList(PanganItem panganItem) {
    if (panganItem.quantity > 1) {
      decreaseItemQuantity(panganItem);
    } else {
      panganItems.remove(panganItem);
    }
    return panganItems;
  }

  void increaseItemQuantity(PanganItem panganItem) =>
      panganItem.incrementQuantity();
  void decreaseItemQuantity(PanganItem panganItem) =>
      panganItem.decrementQuantity();
}
