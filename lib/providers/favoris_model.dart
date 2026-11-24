import 'package:flutter/foundation.dart';

import '../models/destination.dart';

/// Favoris partagés par tous les écrans.
class FavorisModel extends ChangeNotifier {
  // favoris rangés par id : Map<String, Destination>
  final Map<String, Destination> _favoris = {};
  // TODO estFavori(Destination d) -> bool
  bool estFavori(Destination d) => _favoris.containsKey(d.id);
  // TODO getter liste : les destinations favorites
  List<Destination> get liste => _favoris.values.toList();
  // TODO getter nombre
  int get nombre => _favoris.length;
  // TODO basculer(Destination d) : ajoute ou retire,
  bool basculer(Destination d) {
    final ajoute = !_favoris.containsKey(d.id);
    if (ajoute) {
      _favoris[d.id] = d;
    } else {
      _favoris.remove(d.id);
    }
    notifyListeners();
    return ajoute;
  }
  //      prévient les écouteurs, renvoie true si ajouté
}
