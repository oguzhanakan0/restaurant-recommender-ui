import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Restaurant Recommender',
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
          primarySwatch: Colors.deepOrange,
        ),
        home: MyHomePage(title: 'Restaurant Recommender'),
        routes: <String, WidgetBuilder>{
          "/result": (context) => ResultPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController(text: '1.2324, -1.0554');

  Future<dynamic> runPost(
      {required String postString, int timeout = 15}) async {
    Uri uri = Uri(
        // host: '10.0.2.2',
        host: 'oguz.local',
        port: 8000,
        path: 'recommendation-request/',
        scheme: 'http');
    print('[POST] uri : ' + uri.toString());
    print('[POST] body: ' + postString);
    try {
      Response response = await post(uri,
              headers: {
                "Accept": "application/json",
              },
              body: postString)
          .timeout(Duration(seconds: timeout));
      // print('[POST] Response: ' + response.body.toString());
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      print('[POST] Exception: ' + e.toString());
      return {'success': false};
    }
  }

  List<String> restTypes = ['QuickBites', 'CasualDining'];

  List<String> cuisines = [
    'NorthIndian',
    'SouthIndian',
    'Chinese',
    'FastFood',
    'Biryani',
    'Andhra',
    'Continental',
    'Desserts',
    'Cafe',
    'Bakery'
  ];

  List<String> dollarSigns = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  String? _cuisine;
  String? _restType;
  String? _dollarSign;

  @override
  void initState() {
    super.initState();
    _cuisine = cuisines[0];
    _restType = restTypes[0];
    _dollarSign = dollarSigns[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            children: <Widget>[
              Text(
                'What kind of a restaurant would you like?',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Card(
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Cuisine',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: DropdownButtonFormField<String>(
                                    value: cuisines[0],
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        )),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _cuisine = newValue;
                                      });
                                    },
                                    items: cuisines
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList())),
                            Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Restaurant Type',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: DropdownButtonFormField<String>(
                                    value: restTypes[0],
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        )),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _restType = newValue;
                                      });
                                    },
                                    items: restTypes
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList())),
                            Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Approx Cost',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: DropdownButtonFormField<String>(
                                    value: dollarSigns[0],
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        )),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _dollarSign = newValue;
                                      });
                                    },
                                    items: dollarSigns
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList())),
                            Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'My Location',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )),
                                  controller: _locationController,
                                )),
                            ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: double.infinity, height: 48.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    dynamic res = await runPost(
                                        postString: json.encode({
                                      'cuisine': _cuisine,
                                      'restType': _restType,
                                      'dollarSign': _dollarSign,
                                      'location': _locationController.text
                                    }));
                                    if (res['success']) {
                                      Navigator.of(context).pushNamed('/result',
                                          arguments: {
                                            'restaurants': res['restaurants'],
                                            'cur_pos': _locationController.text
                                          });
                                    } else {
                                      print(res);
                                    }
                                  },
                                  child: Text(
                                    'List Restaurants',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                )),
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }
}

class ResultPage extends StatefulWidget {
  ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    List restaurants = args['restaurants'];
    restaurants.forEach((element) {
      element[5] = 5;
    });
    String curPos = args['cur_pos'];
    print(restaurants);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.amber[50],
                                  ),
                                  // width: 200,
                                  child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 180),
                                      child: Text(
                                        '${restaurants[index][0]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(fontSize: 16),
                                      ))),
                              Container(
                                  width: 120,
                                  height: 50,
                                  child: Column(children: [
                                    Row(
                                      children: getIcons(restaurants[index][3]),
                                    )
                                  ]))
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${restaurants[index][1]} - ${restaurants[index][2]}'),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'Value: ${getValue(restaurants[index][5])}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline!
                                          .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      '${getDollarSign(restaurants[index][4])}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline!
                                          .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.directions,
                                            color: Colors.amber[400],
                                          ),
                                          Text(
                                            '${getDistance(restaurants[index][6], restaurants[index][7], curPos)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.amber[800]),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.asset(
                                      'lib/assets/img/' +
                                          'r' +
                                          index.toString() +
                                          '.jpeg',
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.cover))
                            ],
                          )
                        ],
                      ))));
        },
      ),
    );
  }

  String getValue(int n) {
    String res = '';
    for (int i = 0; i < n; i++) res += '\■';
    return res;
  }

  String getDollarSign(int n) {
    String res = '';
    for (int i = 0; i < n; i++) res += '\$';
    return res;
  }

  String getDistance(double x0, double y0, String curpos) {
    double x1 = double.parse(curpos.split(', ')[0]);
    double y1 = double.parse(curpos.split(', ')[1]);
    print(curpos);
    String d =
        sqrt((x1 - x0) * (x1 - x0) + (y1 - x0) * (y1 - x0)).toStringAsFixed(2);
    return '$d miles';
  }

  List<Widget> getIcons(double stars) {
    int n = stars.toInt();
    List<Widget> res = [
      Text(
        'Rating  ',
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      )
    ];
    for (int i = 0; i < n; i++)
      res.add(Icon(
        Icons.star,
        size: 14,
        color: Colors.green,
      ));
    if (double.parse(stars.toString().split('.')[1].substring(0, 1)) > 0.5)
      res.add(Icon(
        Icons.star_half,
        size: 14,
        color: Colors.green,
      ));
    for (int j = 0; j < (6 - res.length); j++)
      res.add(Icon(
        Icons.star_border,
        size: 14,
        color: Colors.green,
      ));
    return res;
  }
}
