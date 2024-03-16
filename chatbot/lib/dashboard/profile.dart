import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import 'detailed_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    Map<String, int> barValues = {
      'Finance': user?.financeBarValue ?? 0,
      'Academic': user?.academicBarValue ?? 0,
      'Career': user?.careerBarValue ?? 0,
    };
    user?.badges = [
      'assets/images/red-badge.png',
      'assets/images/star-badge.png',
      'assets/images/3-bad.png',
      'assets/images/purple-badge.png',
    ];
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 50,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset:
                      const Offset(0, 3), // changes the position of the shadow
                ),
              ],
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.background,
                width: 0.2,
              ),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(children: [
              const SizedBox(
                height: 25,
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          image: user?.photoURL,
                          uid: user?.uid,
                        ),
                      ));
                    },
                    child: Hero(
                      tag: 'userImage${user?.uid}',
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user?.photoURL ??
                            'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                        radius: 60.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      String? imageURL = await StorageService()
                          .captureImage(user ?? MyUser.fromMap({}));
                      if (imageURL == null) {
                        print('Failed!');
                        return;
                      }
                      setState(() {
                        user?.photoURL = imageURL;
                      });
                      await DatabaseService(uid: '')
                          .UpdateStudentCollection(user);
                    },
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.image_search,
                        color: Colors.white,
                      ), // Change the color as needed
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                '${user?.name}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text('${user?.email}'),
            ]),
          ),
          const SizedBox(
            height: 40,
          ),
          for (String key in barValues.keys)
            buildProgressBar(key, barValues[key] ?? 0),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              'Badges',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.0),
                for (String badge in user?.badges ?? [])
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(badge),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildProgressBar(String title, int barValue) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 20.0),
      ),
      SizedBox(height: 20.0),
      MyProgressBar(barValue: barValue)
    ],
  );
}

class MyProgressBar extends StatefulWidget {
  final int barValue;
  MyProgressBar({required this.barValue});
  @override
  _MyProgressBarState createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> {
  // Initial value, can be changed dynamically\
  late int barValue;
  @override
  void initState() {
    // TODO: implement initState
    barValue = widget.barValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: LinearProgressIndicator(
            value: (barValue + 10) / 100, // Normalized value from 0.0 to 1.0
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 10.0,
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          '${barValue + 10}%',
          style: TextStyle(fontSize: 20.0),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     setState(() {
        //       // Incrementing the barValue (just for demonstration)
        //       barValue += 10;
        //       if (barValue > 100) {
        //         barValue = 100;
        //       }
        //     });
        //   },
        //   child: Text('Increase Progress'),
        // ),
      ],
    );
  }
}
