import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:omok/variable/variables.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> database = initDatabase();
  static final VariablesController controller = Get.find();

  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'omok_database.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE omoks(omokDate TEXT PRIMARY KEY, "
            "win INTEGER, tie INTEGER, defeat INTEGER, downCount INTEGER, score INTEGER");
      },
      version: 1,
    );
  }

//게임결과를 로컬db인 SQLite에 저장하는 함수
  static void insert() async {
    final Database db = await database;
    if (controller.v_win.value + controller.v_tie.value + controller.v_defeat.value == 1) {
      //앱 시작후 최초로 기록을 저장할 때는 게임종료시간을 가지고 Sqlite insert 문장을 사용해 저장
      String _today = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      controller.v_today.value = _today;
      await db.rawUpdate("insert into omoks(omokDate, win, tie, defeat, downCount, score) values('$_today', $controller.v_win.value, $controller.v_tie.value, $controller.v_defeat.value, $controller.v_downCount.value, $controller.v_score.value)");
    } else {
      //두번째부터 기록 저장시 update 문장 사용하여 저장
      String _today = controller.v_today.value;
      await db.rawUpdate(
          "update omoks set win = $controller.v_win.value, tie = $controller.v_tie.value, "
          "defeat = $controller.v_defeat.value, downCount = $controller.v_downCount.value, "
          "score = $controller.v_score.value where omokDate = '$_today'");
    }
  }
}
