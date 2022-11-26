import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedServiceProvider = Provider<MySharedServices>((ref) {
  return MySharedServices();
});

class MySharedServices {
  //Getters
  Future<String?> getSharedUUID() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    return pres.getString('uuid');
  }

  //Setters
  Future<void> setSharedUUID(String uuid) async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    await pres.setString('uuid', uuid);
  }

  //remove
  Future<void> removeSharedServices() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    await pres.clear();
  }
}
