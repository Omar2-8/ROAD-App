import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:public_transit_tracking_app/UserRegistration/log_in_user_page.dart';
import 'package:public_transit_tracking_app/get_started_page.dart';
import 'package:public_transit_tracking_app/main.dart';

class SettingsDriverPage extends StatefulWidget {
  const SettingsDriverPage({Key key}) : super(key: key);

  @override
  _SettingsDriverPageState createState() => _SettingsDriverPageState();
}

class _SettingsDriverPageState extends State<SettingsDriverPage> {

  final _firebaseAuth = FirebaseAuth.instance;

  int selectedChoiceN = 0; //0=all //1=mute
  int selectedChoiceP = 0; //0=only me //1=public
  void selctedfunA(){
    if (selectedChoiceN==0)
      selectedChoiceN=1;
    else selectedChoiceN=0;
  }
  void selctedfunB(){
    if (selectedChoiceP==0)
      selectedChoiceP=1;
    else selectedChoiceP=0;
  }

  @override
  Widget build(BuildContext context) {
    print(currentUser.value.toString());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'SETTINGS',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Container(
                color: Colors.blue.withOpacity(.1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('ME', style: TextStyle(color: Colors.blue)),
                    leading: Icon(Icons.edit, color: Colors.blue),
                    trailing:
                    Text('${driverType.value=='t'?currentTaxiUser.value?.userName:currentBusUser.value?.userName??''}', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: InkWell(
                onTap: (){
                  selctedfunA();
                  setState(() {
                  });
                },
                child: Container(
                  color: Colors.blue.withOpacity(.1),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text('Notifications', style: TextStyle(color: Colors.blue)),
                      leading: Icon(Icons.notifications, color: selectedChoiceN== 0 ? Colors.blue : Colors.white),
                      trailing:
                      Text(selectedChoiceN==0?'ALL':'Mute', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Container(
                color: Colors.blue.withOpacity(.1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('General', style: TextStyle(color: Colors.blue)),
                    leading: Icon(Icons.settings, color: Colors.blue),

                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Container(
                color: Colors.blue.withOpacity(.1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('Account', style: TextStyle(color: Colors.blue)),
                    leading: Icon(Icons.person, color: Colors.blue),
                    trailing:
                    Text('${driverType.value=='t'?currentTaxiUser.value?.email:currentBusUser.value?.email??''}', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: InkWell(
                onTap: (){
                  selctedfunB();
                  setState(() {
                  });
                },
                child: Container(
                  color: Colors.blue.withOpacity(.1),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text('Privacy', style: TextStyle(color: Colors.blue)),
                      leading: Icon(Icons.lock, color: Colors.blue),
                      trailing:
                      Text(selectedChoiceP==0?'Only me':'Public', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Container(
                color: Colors.blue.withOpacity(.1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('Logout', style: TextStyle(color: Colors.blue)),
                    leading: Icon(Icons.logout, color: Colors.blue),
                    onTap: () {
                      setState(() {
                        currentUser.value=null;
                        _firebaseAuth.signOut();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetStartedPage(),), (route) => false);
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Container(
                color: Colors.blue.withOpacity(.1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('Help', style: TextStyle(color: Colors.blue)),
                    leading: Icon(Icons.help, color: Colors.blue),
                    trailing:
                    Text('Questions?', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
