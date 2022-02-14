import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SwitchController extends GetxController {
  final data = GetStorage();
  bool notify = true;

  setsSwitch(bool value) async{
    notify = value;
   await data.write('switch', notify);
    update();
  }

  switchState() {
    if (data.read('switch') != null) {
      notify = data.read('switch');
    }
    print('that is worked $notify');
    update();
  }
}
