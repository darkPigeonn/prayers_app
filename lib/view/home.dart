import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayers_app/model/resource_model.dart';
import 'package:prayers_app/providers/resources_provider.dart';
import 'package:prayers_app/services/notification.dart';
import 'package:prayers_app/view/detailResource.dart';
import 'package:prayers_app/view/info.dart';
import 'package:prayers_app/view/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

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

  getGreeting() {
    DateTime now = DateTime.now();
    var hour = now.hour;
    String sapaan = '-';
    if (hour > 00 && hour < 12) {
      sapaan = 'Pagi';
    } else if (hour >= 12 && hour <= 16) {
      sapaan = 'Siang';
    } else if (hour > 16 && hour <= 18) {
      sapaan = 'Sore';
    } else {
      sapaan = 'Malam';
    }
    return sapaan;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGreeting();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Future refreshData() async {
      ref.refresh(prayersProvider);
      ref.refresh(todayPrayerProvider);
    }

    final _listPrayers = ref.watch(prayersProvider);
    final todayPrayers = ref.watch(todayPrayerProvider);
    final eventToday = ref.watch(eventsTodaysProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Selamat ' + getGreeting() + ' !',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                  icon: Icon(Icons.settings)),

            ],
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
                  loading: () => SkeletonGridLoader(
                        items: 1,
                        period: Duration(seconds: 3),
                        highlightColor: Color.fromARGB(255, 255, 255, 255),
                        direction: SkeletonDirection.ltr,
                        childAspectRatio: 1,
                        builder: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Jadwal Misa Hari Ini',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              child: eventToday.when(
                  data: (_data) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shadowColor: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.church_rounded,
                                    size: 40,
                                    color: Color.fromARGB(255, 255, 114, 7),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _data[index]['title'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 14,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(_data[index]['venue'])
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(_data[index]['time']
                                                        .toString() ==
                                                    'null'
                                                ? '-'
                                                : _data[index]['time'])
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  error: (err, s) {
                    return Center(
                      child: Text('Gagal Mendapatkan Data'),
                    );
                  },
                  loading: () => SkeletonGridLoader(
                        builder: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: 10,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        items: 1,
                        period: Duration(seconds: 2),
                        highlightColor: Colors.grey,
                        direction: SkeletonDirection.ltr,
                      ))),
          SizedBox(
            height: 20,
          ),

          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Doa lain - lain',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
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
                    loading: () => SkeletonLoader(
                          items: 1,
                          period: Duration(seconds: 3),
                          highlightColor: Color.fromARGB(255, 255, 255, 255),
                          direction: SkeletonDirection.ltr,
                          builder: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20)),
                          ),
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
