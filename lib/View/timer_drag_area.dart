import 'package:flutter/cupertino.dart';

class TimerDragArea extends StatelessWidget {
  TimerDragArea({
    Key? key,
    required this.globalKey,
    required this.setMinutes,
  }) : super(key: key);
  final GlobalKey globalKey;
  final Function setMinutes;

  var isBeginDrag = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // シングルタップ開始後、そのままタッチを動かすなどしてシングルタップがキャンセルされる時にコール
      onTapCancel: () {
        isBeginDrag = true;
      },
      onPanUpdate: (dragUpdateDetails) {
        final x = dragUpdateDetails.localPosition.dx;
        final y = dragUpdateDetails.localPosition.dy;
        final widgetWidth = globalKey.currentContext!.size!.width;
        final widgetHeight = globalKey.currentContext!.size!.height;
        setMinutes(dragUpdateDetails, x, y, widgetWidth / 2, widgetHeight / 2,
            isBeginDrag);
        isBeginDrag = false;
      },
    );
  }
}
