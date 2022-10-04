import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayers_app/model/resource_model.dart';
import 'package:prayers_app/providers/resources_provider.dart';
import 'package:prayers_app/services/notification.dart';
import 'package:prayers_app/view/detailResource.dart';
import 'package:prayers_app/view/info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class HomePage extends StatefulWidget {
//   HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             ElevatedButton(
//                 onPressed: () async {
//                   await scheduleWorkTime(0, 'Waktunya Jam Pulang',
//                       'Jangan lupa klik jam pulang ya ', Time(10, 55));
//                 },
//                 child: Text('data')),
//             // ScreenNew(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late bool isActiveNotif = false;

  setNotificationStatus(int code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //mengaktifkan notifikasi
    if (code == 1) {
      setState(() {
        isActiveNotif = true;
      });
      pref.setBool('isNotificationStatus', true);
    } else if (code == 0) {
      setState(() {
        isActiveNotif = false;
      });
      pref.setBool('isNotificationStatus', false);
    }
  }

  @override
  Widget build(BuildContext context) {


    Future refreshData() async {
      ref.refresh(prayersProvider);
      ref.refresh(todayPrayerProvider);
    }
    print("isActiveNotif");
    print(isActiveNotif);


    final _listPrayers = ref.watch(prayersProvider);
    final todayPrayers = ref.watch(todayPrayerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: isActiveNotif
                  ? Icon(Icons.notifications_active)
                  : Icon(Icons.notifications_none),
              onPressed: () async {
                if (!isActiveNotif) {
                  await scheduleWorkTime(0, 'Waktunya Doa', '', Time(12, 00));
                  setNotificationStatus(1);
                  Fluttertoast.showToast(
                    msg: 'Notifikasi Pulang On',
                    backgroundColor: Color.fromARGB(255, 2, 115, 0),
                    textColor: Colors.white,
                  );
                } else {
                  await cancelNotification();
                  setNotificationStatus(0);
                  Fluttertoast.showToast(
                    msg: 'Notifikasi Pulang Off',
                    backgroundColor: Color.fromARGB(255, 2, 115, 0),
                    textColor: Colors.white,
                  );
                }

                print("Notifikasi Doa Aktif");
              },
            ),
            Text('KUMPULAN DOA'),
            IconButton(
              icon: Icon(Icons.replay),
              onPressed: () {
                refreshData();
              },
            ),
          ],
        ),
        actions: [],
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Doa Hari ini',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              child: todayPrayers.when(
                  data: (_data) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailResource(dataDetails: _data)));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 76, 148, 198),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/bg-jp.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.all(30),
                                child: Text(
                                  _data.title!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        // ),
                      ),
                    );
                  },
                  error: (err, s) {
                    return Center(
                      child: Text(err.toString()),
                    );
                  },
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ))),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Doa lain - lain',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: Container(
                child: _listPrayers.when(
                    data: (_data) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailResource(
                                        dataDetails: _data[index],
                                      ),
                                    ),
                                  );
                                },
                                child: CustomListItemTwoCard(
                                  title: _data[index].title!,
                                  subtitle: _data[index].excerpt!,
                                  author: _data[index].author!,
                                  publishDate: _data[index].publishDate!,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    error: (err, s) {
                      return Center(
                        child: Text(err.toString()),
                      );
                    },
                    loading: () => Center(
                          child: CircularProgressIndicator(),
                        ))),
          ),
        ],
      )),
    );
  }
}

class CustomListItemTwoCard extends StatelessWidget {
  const CustomListItemTwoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: SizedBox(
        height: 75,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0.0, 2.0, 0.0),
                child: _CardDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CardDescription extends StatelessWidget {
  const _CardDescription({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    Moment rawDate = Moment.parse(publishDate);
    var date = rawDate.format('dd-MM-yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Row(
          children: [
            Container(
              child: Icon(
                Icons.book,
                size: 50,
                color: Color.fromARGB(255, 255, 114, 7),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ))
      ],
    );
  }
}
