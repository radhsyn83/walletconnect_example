import 'package:get_storage/get_storage.dart';
import 'package:walletconnect/model/settle_model.dart';

class LocalStorage {
  static void setSession(SettleModel data) {
    final box = GetStorage();
    box.write(_var.SESSION, data);
  }

  static Future<SettleModel?> get sessions async {
    final box = GetStorage();
    var sess = await box.read(_var.SESSION);
    if (sess != null) {
      if (sess is SettleModel) {
        return sess;
      } else {
        return SettleModel.fromJson(sess);
      }
    } else {
      return null;
    }
  }

  static Future<void> clear() async {
    final box = await GetStorage();
    box.remove(_var.SESSION);
  }
}

abstract class _var {
  static const SESSION = "SESSION";
}
