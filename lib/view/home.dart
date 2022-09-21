import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayers_app/providers/resources_provider.dart';
import 'package:prayers_app/view/detailResource.dart';
import 'package:simple_moment/simple_moment.dart';

class HomePage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future refreshData() async {
      ref.refresh(prayersProvider);
    }
    final _listPrayers = ref.watch(prayersProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('KUMPULAN DOA'),
        actions: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () {
              refreshData();
            },
          ),
        ],
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
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/bg-prayer.jpeg',
                  fit: BoxFit.fill,
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      '',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
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
