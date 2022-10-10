import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Sample',
      home: MyHomePage(title: 'Flutter Sample'),
    );
  }
}

//StatefluWidgetを使って描画タイミングを管理
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List items = [];

//GoogleBoooksAPI取得 非同期処理
  Future<void> getData() async {
    var response = await http.get(Uri.https(
        'www.googleapis.com',
        '/books/v1/volumes',
        {'q': '{fltter}', 'maxResults': '40', 'langRestrict': 'ja'}));
    var jsonResponse = jsonDecode(response.body);
//stateにセット
    setState(() {
      items = jsonResponse['items'];
    });
  }

  @override
  void initState() {
    super.initState();

    //API呼び出したら描画 （データ更新・再描画）
    getData();
  }

//ListViewでAPIから取得した値を表示
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sample'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Image.network(
                    items[index]['volumeInfo']['imageLinks']['thumbnail'],
                  ),
                  title: Text(items[index]['volumeInfo']['title']),
                  subtitle: Text(items[index]['volumeInfo']['publishedDate']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
