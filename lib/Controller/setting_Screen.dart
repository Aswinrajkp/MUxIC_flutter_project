import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class SettingsController extends GetxController {
  final data = GetStorage();
  bool switched = true;


  changeSwitchState(bool value) {
    switched = value;
    data.write('switch', switched);
    update();
    print("working");
  }
    switchState() {
    if (data.read('switch') != null) {
      switched = data.read('switch');
      update();
      print('worked');
    }
  }


  @override
  void onInit() async {
     await GetStorage.init;
    switchState();
    print(data.read('switch'));
    // TODO: implement onInit
    super.onInit();
  }
}
