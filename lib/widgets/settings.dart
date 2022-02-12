import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_project/Controller/setting_Screen.dart';
import 'package:music_project/widgets/home.dart';
import 'package:music_project/widgets/miniPlayer.dart';

bool notification = true;

class Settings extends GetView<SettingsController> {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = GetStorage();
    var controller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GetBuilder<SettingsController>(builder: (context)=>
      Column(
        children: [
          SwitchListTile(value: controller.switched,title: Text('Notification',style: TextStyle(color: Colors.white),), onChanged:(value) {
                        controller.changeSwitchState(value);
                        controller.switchState();
                      } ),
          const ListTile(
            title: Text(
              'privacy policy',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const ListTile(
            title: Text(
              'Terms and Conditions',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(LicensePage(applicationName: 'MUxIC',applicationVersion: '1.0.0',));
            },
            title: Text(
              'About',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const ListTile(
            title: Text(
              'Version',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              '1.0.0',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),),
       
      bottomNavigationBar: BottomPlaying(),
    );
  }
}
