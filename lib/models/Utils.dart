import 'package:sae_mobile/models/Objet.dart';
import 'package:sae_mobile/models/queries/local/annonce.dart';

class Utils {
  /// Vérifie si un objet est réservable.
  ///
  /// [objet] est l'objet à vérifier.
  ///
  /// Retourne un booléen, vrai si l'objet est réservable, faux sinon.
  static Future<bool> isObjetReservable(Objet objet) async {
    final annonces = await AnnonceQueries.getAnnonces();
    for (var annonce in annonces) {
      if (annonce['idObj'] == objet.id && annonce['idEtat'] != 4 && annonce['dateDeb'] < DateTime.now().millisecondsSinceEpoch && annonce['dateFin'] > DateTime.now().millisecondsSinceEpoch) {
        return false;
      }
    }
    return true;
  }
}