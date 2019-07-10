import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'db_manager.dart';

class SqflitePage extends StatefulWidget {
  final String title;

  SqflitePage({this.title, Key key}): super(key: key);
  
  @override
  State<StatefulWidget> createState() => _SqflitePageState();
}

class _SqflitePageState extends State<SqflitePage> {
  String userName;
  String password;
  final DBManager dbManager = new DBManager();
  String record = '';

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
  }

  Future query() async {
    String dbFolderPath = await getDatabasesPath();
    await dbManager.open(dbFolderPath + 'user.db');
    User user = await dbManager.getUser(1);
    
    if (user != null) {
      setState(() {
        record = user.toString();
      });
    }
  }

  void insert() {
    dbManager.insert(User(userName, password));
  }

  void update() {
    dbManager.update(User(userName, password));
  }

  void delete() {
    dbManager.delete(1);
  }

  Future list() async {
    String dbFolderPath = await getDatabasesPath();
    await dbManager.open(dbFolderPath + 'user.db');
    List<User> userList = await dbManager.getAllUsers();
    
    if (userList != null) {
      setState(() {
        record = userList.toString();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Username",
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      onChanged: (text) {
        userName = text;
      },
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      onChanged: (text) {
        password = text;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: Icon(Icons.account_circle, size: 100)
              ),
              SizedBox(height: 80.0),
              emailField,
              SizedBox(height: 25.0),
              passwordField,
              SizedBox(
                height: 35.0,
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  SizedBox(
                    width: 60,
                    child: RaisedButton(
                      child: Text('插入'),
                      onPressed: insert,
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 60,
                    child: RaisedButton(
                      child: Text('更新'),
                      onPressed: update,
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 60,
                    child: RaisedButton(
                      child: Text('检索'),
                      onPressed: list,
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 60,
                    child: RaisedButton(
                      child: Text('清除'),
                      onPressed: delete,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(record)
            ],
          ),
        )
      ),
    );
  }
}