class UsersPlayModel {
  final String? roomId;
  final int? x;
  final int? y;
  final int? step;
  final bool? result;
  //내가 승리면 상대에게 패배 전달, 내가 패배면 상대에게 승리 전달, 무승부는 그대로 전달

  UsersPlayModel({
    this.roomId, this.x, this.y, this.step, this.result
  });

  UsersPlayModel.fromJson(Map<String, dynamic> json)
      : roomId = json['room_id'],
        x = json['x'],
        y = json['y'],
        step = json['step'],
        result = json['result'];

  Map<String, dynamic> toJson() {
    //toJson() 함수는 개발자가 직접 호출하지 않고 JSON 문자열로 변환할때 사용하는 jsonEncode() 함수 내부에서 자동 호출됨
    return {
      'room_id' : roomId,
      'x' : x,
      'y' : y,
      'step' : step,
      'result' : result
    };
  }
}