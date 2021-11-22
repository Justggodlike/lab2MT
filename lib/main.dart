import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future getUserData() async {
    var response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var jsonData = jsonDecode(response.body);
    List<User> users = [];
    for (var u in jsonData) {
      User user = User(u["name"], u["email"], u["username"], u["website"], u["phone"]);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Card(
            child: FutureBuilder <dynamic>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center (
                    child: Text('Loading...'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i].name),
                        subtitle: Text(snapshot.data[i].username),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListItem(
                                  name: snapshot.data[i].name,
                                  website: snapshot.data[i].website,
                                  phone: snapshot.data[i].phone,
                                  email: snapshot.data[i].email
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            )
        ),
    );
  }
}

class User {
  final String name, email, username, website, phone;
  User(this.name, this.email, this.username, this.phone, this.website);
}

class ListItem extends StatelessWidget {
  final String name;
  final String phone;
  final String website;
  final String email;

  const ListItem({Key? key, required this.name,
    required this.phone, required this.website, required this.email}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(name + '\n' + phone + '\n' + website + '\n' + email,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
              backgroundColor: Colors.white,
            decoration: TextDecoration.none
          )

      ),
    );
  }
}
