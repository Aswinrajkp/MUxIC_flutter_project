
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_project/Controller/setting_Screen.dart';
import 'package:music_project/Controller/switch_controll.dart';
import 'package:music_project/widgets/home.dart';
import 'package:music_project/widgets/miniPlayer.dart';

bool notification = true;

class Settings extends StatelessWidget{
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SwitchController controller = Get.put(SwitchController());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: 
      Column(
        children: [
          GetBuilder<SwitchController>(builder: (context){
            return
             SwitchListTile(value: controller.notify,title: Text('Notification',style: TextStyle(color: Colors.white),), onChanged:(value) {
                        controller.setsSwitch(value);
                      } );
          },),
         
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
      ),
        bottomNavigationBar: BottomPlaying(),);
       
  }}
  
