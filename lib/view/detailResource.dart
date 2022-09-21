import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:prayers_app/model/resource_model.dart';
import 'package:simple_moment/simple_moment.dart';

class DetailResource extends StatefulWidget {
  final ResourceModel dataDetails;
  DetailResource({Key? key, required this.dataDetails}) : super(key: key);

  @override
  State<DetailResource> createState() => _DetailResourceState();
}

class _DetailResourceState extends State<DetailResource> {
  bool listen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
  }

  final String urlImage =
      'https://static.imavi.org/komunio/archived/komunio_media/';
  @override
  Widget build(BuildContext context) {
    ResourceModel data = widget.dataDetails;

    Moment rawDate = Moment.parse(data.publishDate!);
    var date = rawDate.format('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Color.fromARGB(255, 106, 0, 124),
        actions: [
          Padding(
            padding: EdgeInsets.all(0),
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                data.title!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 139, 9, 0)),
                    child: Text(
                      data.author!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 213, 99, 0)),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Html(
                data: data.content,
                style: {
                  "body": Style(
                      fontSize: FontSize(16.0), textAlign: TextAlign.justify)
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}
