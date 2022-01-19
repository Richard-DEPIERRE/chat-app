import 'package:flutter/material.dart';

class FavoriteContacts extends StatelessWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Favorite Contacts",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                  color: Colors.blueGrey,
                  iconSize: 30.0,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120.0,
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundImage: NetworkImage(
                          "https://c.tenor.com/fFntTHJYFPMAAAAM/random.gif",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      "Richie",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
