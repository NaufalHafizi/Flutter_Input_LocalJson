import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main () {
  runApp(MaterialApp(
    title: 'Input Json',
    theme: new ThemeData(
      primarySwatch: Colors.red,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();

  File jsonFile;
  Directory dir;
  String fileName = "data.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;

  @override
  void initState(){
    super.initState(); 
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist = jsonFile.existsSync();
      if (fileExist) this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
    });
  }

  @override
  void dispose() {
    input1.dispose();
    input2.dispose();
    super.dispose();
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file");
    File file = new File(dir.path + "/" +fileName);
    file.createSync();
    fileExist = true;
    file.writeAsStringSync(jsonEncode(content));
  }

  void writeToFile(String key,  String value) {
    print("Writing to file");
    Map<String, dynamic> content = {key: value};
    if (fileExist){
      print("File Exist");
      print(dir.path + "/" +fileName);
      Map<String, dynamic> jsonFileContent = jsonDecode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      print("File does not exist");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Try'),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
          children: <Widget>[
            SizedBox(height: 80,),
            Text('File Content:'),
            Text(fileContent.toString()),
            Text('Add to JSON file'),
            SizedBox(height: 80,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50,),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Input 1',
                    icon: Icon(Icons.input),
                  ),
                  controller: input1,
                ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50,),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Input 2',
                    icon: Icon(Icons.input),
                  ),
                  controller: input2,
                ),
            ),
            SizedBox(height: 60,),
            RaisedButton(
                child: Text('Add key, value pair'),
                onPressed: () => writeToFile(input1.text, input2.text),
            )
          ],
        ),
              ),
      ),
    );
  }
}
