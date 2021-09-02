import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:justdoit/validators.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'strings.dart' as str;
import 'extensions.dart';
import 'data.dart';
import 'dialog.dart';

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'health_record.db'),
    onCreate: (db, version) {
      return db.execute(
        """
        CREATE TABLE blood_pressure(
          id INTEGER PRIMARY KEY,
          created_at INTEGER,
          min INTEGER,
          max INTEGER
        )
        """,
      );
    },
    version: 1,
  );
  // SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MainApp(db: database));
}

class MainApp extends StatelessWidget {
  final Database db;

  const MainApp({Key key, this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "title",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        errorColor: Colors.red,
        fontFamily: 'Zar',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 24.0),
          bodyText1: TextStyle(fontFamily: 'Titr'),
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          selectedColor: Color.fromRGBO(242, 182, 4, 1),
          disabledColor: Color.fromRGBO(20, 17, 89, 1),
        ),
        bannerTheme: MaterialBannerThemeData(
          backgroundColor: Color.fromRGBO(32, 15, 140, 1),
        ),
      ),
      home: HomePage(db: db),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale("fa", "IR")],
      locale: Locale("fa", "IR"),
    );
  }
}

class HomePage extends StatelessWidget {
  final Database db;

  const HomePage({Key key, this.db}) : super(key: key);

  Widget bloodPressure(BuildContext context) => GestureDetector(
        onTap: () async {
          BloodPressure data = BloodPressure();
          final changed = await SimpleInputDialog.asDialog(
            context: context,
            title: str.bloodPressureButton,
            forms: [
              FormData(
                title: str.minimum,
                input: TextFormField(
                  decoration: InputDecoration(
                    hintText: str.bloodPressureMinHint,
                  ),
                  validator: validateEmptyString,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSaved: (v) {
                    data = data.replaceWith(min: v.asInt);
                  },
                  showCursor: false,
                ),
              ),
              FormData(
                title: str.maximum,
                input: TextFormField(
                  decoration: InputDecoration(
                    hintText: str.bloodPressureMinHint,
                  ),
                  validator: validateEmptyString,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSaved: (v) {
                    data = data.replaceWith(max: v.asInt);
                  },
                  showCursor: false,
                ),
              ),
            ],
          );
          if (!changed) {
            return;
          }
          final inserted =
              await db.insert("blood_pressure", data.validate().toMap()) > 0;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(inserted ? str.successMessage : str.failureMessage),
              backgroundColor: inserted ? Colors.lightGreen : Colors.redAccent,
            ),
          );

          final a = await db.query('blood_pressure');
          a.forEach((element) {
            print(BloodPressure.fromMap(element));
          });
        },
        child: Container(
          child: Text(str.bloodPressureButton),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: GridView.count(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 1,
          padding: EdgeInsets.all(10),
          children: [
            bloodPressure(context),
          ],
        ),
      ),
    );
  }
}
