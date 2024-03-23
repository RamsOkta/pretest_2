import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final startColor = Color(0xFFaa7ce4);
final endColor = Color.fromARGB(255, 88, 19, 43);
final titleColor = Color.fromARGB(255, 196, 38, 38);
final textColor = Color.fromARGB(255, 162, 192, 53);
final shadowColor = Color(0xffe9e9f4);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: 180,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [startColor, endColor])),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: IconButton(
                        icon: Icon(
                          Icons.dehaze,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                child: FutureBuilder<User>(
                  future: fetchUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ProfileDetails(user: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<User> fetchUser() async {
  final response = await http.get(Uri.parse('https://randomuser.me/api/'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final userJson = data['results'][0];
    return User.fromJson(userJson);
  } else {
    throw Exception('Failed to load user');
  }
}

class ProfileDetails extends StatelessWidget {
  final User user;

  const ProfileDetails({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(user.picture), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color: Colors.blueAccent.withOpacity(.2), width: 1)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            color: titleColor,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.only(left: 30, right: 20, top: 8),
          width: 320,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 30,
                    spreadRadius: 5)
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Gender',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        user.gender,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              onPressed: () {}),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Text(
                'Location',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                '${user.city}, ${user.country}',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final String gender;
  final String city;
  final String country;
  final String picture;

  User({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.city,
    required this.country,
    required this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      gender: json['gender'],
      city: json['location']['city'],
      country: json['location']['country'],
      picture: json['picture']['large'],
    );
  }
}
