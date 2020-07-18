import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppModel>(context);
    return Column(
      children: <Widget>[
        FittedBox(
          fit: BoxFit.fitWidth,
          child: FlatButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final key = 'prefferedOrientation';
              var state = prefs.getInt(key) ?? 0;
              state++;
              if (state > 1) state = 0;
              setPrefferedOrientation(app, state);
              prefs.setInt(key, state);
            },
            child: Text(
              'Orientation: ${app.prefferedOrientationType()}',
              textScaleFactor: 2,
            ),
          ),
        ),
      ],
    );
  }

  static nextOrientationView(AppModel app) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'prefferedOrientation';
    var state = prefs.getInt(key) ?? 0;
    switch (state) {
      case 0:
        state++;
        setPrefferedOrientation(app, state);
        prefs.setInt(key, state);
        break;
      case 1:
        app.isChatVisible = !app.isChatVisible;
        break;
    }
    print(state);
    print(app.isChatVisible);
  }

  static readPrefferedOrientation(AppModel app) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'prefferedOrientation';
    var state = prefs.getInt(key) ?? 0;
    setPrefferedOrientation(app, state);
  }

  static setPrefferedOrientation(AppModel app, int state) {
    switch (state) {
      case 0:
        SystemChrome.setPreferredOrientations([]);
        break;
      case 1:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
        break;
    }
    app.setPrefferedOrientation(state);
  }
}
