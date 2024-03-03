import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'models/omok.dart';

class OmokListApp extends StatefulWidget {
  final Future<Database> database;
  OmokListApp(this.database);
  @override
  State<StatefulWidget> createState() => _OmokListApp();
}

class _OmokListApp extends State<OmokListApp> {
  Future<List<Omok>>? OmokList;

  Future<List<Omok>> getOmokList() async {
    final Database database = await widget.database;
    List<Map<String, dynamic>> maps = await database.rawQuery(
        'select omokDate, win, tie, defeat, downCount, score from omoks order by score desc');
    return List.generate(maps.length, (i) {
      return Omok(
        omokDate: maps[i]['omokDate'],
        win: maps[i]['win'],
        tie: maps[i]['tie'],
        defeat: maps[i]['defeat'],
        downCount: maps[i]['downCount'],
        score: maps[i]['score'],
      );
    });
  }

  void _removeAllTodos() async {
    final Database database = await widget.database;
    database.rawDelete('delete from omoks');
    setState(() {
      OmokList = getOmokList();
    });
  }

  @override
  void initState() {
    super.initState();
    OmokList = getOmokList() as Future<List<Omok>>?;
  }

  @override
  Widget build(BuildContext context) {
    //게임 결과 화면
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rank'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  return const CircularProgressIndicator();
                case ConnectionState.none:
                  return const CircularProgressIndicator();
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Omok omok = (snapshot.data as List<Omok>)[index];
                        return ListTile(
                          subtitle: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(0),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        //1 좌 - 랭킹
                                        Text(
                                          'Ranking',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.lightBlueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        //1 우 - 일시, 점수
                                        Text(
                                          omok.omokDate!,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${omok.win!}승 ${omok.tie!}무 ${omok.defeat!}패 \n수순 ${omok.downCount!}점수 ${omok.score!}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: (snapshot.data as List<Omok>).length,
                    );
                  } else {
                    return const Text('No Data');
                  }
              }
              return const CircularProgressIndicator();
            },
            future: OmokList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete'),
              content: const Text('Do you want to delete all data?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
              ],
            );
          });
          if(result == true) {
            _removeAllTodos();
          }
        },
        child: const Icon(Icons.remove),
      ),
    );
  }
}
