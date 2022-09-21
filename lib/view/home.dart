import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayers_app/providers/resources_provider.dart';

class HomePage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _listPrayers = ref.watch(prayersProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('KUMPULAN DOA'),
      ),
      body:SafeArea(child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _listPrayers.when(
              data: (_data) {
                return  Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {

                    },
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
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                "title",
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
                                "subtitle",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
              ) )
           
          ],
        ),
      )),
    );
  }
}


