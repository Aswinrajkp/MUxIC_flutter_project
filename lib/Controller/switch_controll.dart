import 'package:get/get.dart';

class SwitchController extends GetxController {
 bool notify = true;

  setsSwitch( bool value){
    notify = value;
    update();
  }
  
}