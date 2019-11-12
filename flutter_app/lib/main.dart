import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/powerInfo.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _dataSelecionada;
  String _dataFormatada;
  var _ecuidController = TextEditingController(text: '');


  @override
  void initState() {
    _dataSelecionada = DateTime.now().year.toString()+"/"+ DateTime.now().month.toString() +"/"+ DateTime.now().day.toString();
    _dataFormatada = DateTime.now().day.toString()+"/"+ DateTime.now().month.toString() +"/"+ DateTime.now().year.toString();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Data Selecionada',
            ),
            Text(
              '$_dataFormatada',
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 3, 5),
//                      maxTime: DateTime(2019, 6, 7),
                      theme: DatePickerTheme(
                          backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          doneStyle:
                          TextStyle(color: Colors.white, fontSize: 16)),
                      onChanged: (date) {
                        print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                        setState(() {
                          _dataSelecionada = date.year.toString()+"/"+ date.month.toString() +"/"+ date.day.toString();
                          _dataFormatada = date.day.toString()+"/"+ date.month.toString() +"/"+ date.year.toString();
                        });
                      }, onConfirm: (date) {
//                        print('confirm $date');
                        setState(() {
                          _dataSelecionada = date.year.toString()+"/"+ date.month.toString() +"/"+ date.day.toString();
                          _dataFormatada = date.day.toString()+"/"+ date.month.toString() +"/"+ date.year.toString();
                        });
                        print('confirm $_dataSelecionada');
                      }, currentTime: DateTime.now(), locale: LocaleType.pt);
                },
                child:
                  Icon(
                    Icons.calendar_today,
                    size: 50,

                  ),
//                  Text(
//                  'show date picker(custom theme &date time range)',
//                  style: TextStyle(color: Colors.blue),
//                  )
            ),
            Container(
              width:200,
              child:
            TextFormField(
              controller: _ecuidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ECU ID'
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
        onPressed: (){
          createPost(_dataSelecionada, _ecuidController.text);
        },
        tooltip: 'Increment',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }




  Future<PowerInfo> createPost(String dataSelecionada, String ecuId) async{

    String url = 'http://api.apsystemsema.com:8073/apsema/v1/ecu/getPowerInfo';

//    String params = "{ecuId:'"+ ecuId +"',filter:'power', date:'"+dataSelecionada+"' }";
    String params = "ecuId="+ecuId+"&filter=power&date="+dataSelecionada;

    print(params);

    final response = await http.post('$url',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
        },
        body: params
    );

    if (response.statusCode == 200) {
      print(response.body);
//      var jsonResponse = convert.jsonDecode(response.body);
//      var itemCount = jsonResponse['totalItems'];
//      print("Number of books about http: $itemCount.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }




    return null;
  }




}
