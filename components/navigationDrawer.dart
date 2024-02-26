import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/utils/constant.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Constants.primaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) {
  final size = MediaQuery.of(context).size;
  // DatabaseService databaseService = Get.put(DatabaseService());
  return Material(
    color: const Color.fromARGB(255, 245, 245, 245),
    child: InkWell(
      child: Container(
        padding: EdgeInsets.only(
          top: size.height * .05,
          bottom: size.height * .05,
          left: size.width * .1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Constants.primaryColor,
              maxRadius: 50,
              minRadius: 50,
              child: ClipOval(
                child: Image.asset(
                  "assets/comlogo.png",
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  "Emmanuel Richard",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                DelegatedText(
                  text: "CST20HND0558",
                  fontSize: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMenuItems(BuildContext context) {
  // DatabaseService databaseService = Get.put(DatabaseService());
  return Container(
    padding: const EdgeInsets.all(15),
    child: Wrap(runSpacing: 5, children: [
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.people),
        title: const Text('Students'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.people),
        title: const Text('Candidates'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.file_copy),
        title: const Text('Results'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Personal Details'),
          onTap: () {
            Navigator.pop(context);
          }),
      const Divider(
        color: Colors.black54,
        thickness: 1,
      ),
      ListTile(
        leading: const Icon(Icons.login_rounded),
        title: const Text('Logout'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Log out'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            },
          );
        },
      ),
    ]),
  );
}
