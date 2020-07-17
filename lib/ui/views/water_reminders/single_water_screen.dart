import 'package:MedBuzz/core/constants/route_names.dart';
import 'package:MedBuzz/core/database/water_taken_data.dart';
import 'package:MedBuzz/core/models/water_reminder_model/water_reminder.dart';
import 'package:MedBuzz/ui/widget/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:MedBuzz/ui/size_config/config.dart';
import 'package:MedBuzz/core/database/waterReminderData.dart';
import 'package:MedBuzz/ui/navigation/app_navigation/app_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/notifications/water_notification_manager.dart';
import 'schedule_water_reminder_model.dart';

class SingleWater extends StatefulWidget {
  SingleWater({this.water});

  final WaterReminder water;

  @override
  _SingleWaterState createState() => _SingleWaterState();
}

class _SingleWaterState extends State<SingleWater> {
  WaterReminder waterReminder;
  WaterNotificationManager waterNotificationManager =
      WaterNotificationManager();

  Navigation navigation = Navigation();

  final db = WaterReminderData();

  @override
  Widget build(BuildContext context) {
    var waterTakenDB = Provider.of<WaterTakenData>(context, listen: true);
    waterTakenDB.getWaterTaken();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: Config.yMargin(context, 1)),
                child: FlatButton.icon(
                    onPressed: () {
                      _deleteDialog();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    )),
              ),
              //SizedBox(height: Config.yMargin(context, 3)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Config.xMargin(context, 5.33)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: Config.xMargin(context, 44),
                      child: Text(
                        'Drink ${widget.water.ml} ml of water',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: Config.textSize(context, 5.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(right: Config.xMargin(context, 5)),
                      child: Image.asset('images/waterdrop.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Config.yMargin(context, 3)),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: Config.xMargin(context, 5.33),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: Config.textSize(context, 4.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: Config.yMargin(context, 1.0)),
                        child: Text(
                          widget.water.description ?? 'No description given',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: Config.textSize(context, 4),
                          ),
                          //\n
                        ),
                      ),
                      SizedBox(height: Config.yMargin(context, 10)),
                      Text(
                        'Frequency',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: Config.textSize(context, 4.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: Config.yMargin(context, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Every ${widget.water.interval} minute(s) Daily',
                              style: TextStyle(
                                fontSize: Config.textSize(context, 4),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  "Wake Time: ${DateFormat.jm().format(widget.water.startTime)}",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Config.textSize(context, 3.6),
                                  ),
                                ),
                                SizedBox(height: Config.yMargin(context, 2)),
                                Text(
                                  "Sleep Time: ${DateFormat.jm().format(widget.water.endTime)}",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Config.textSize(context, 3.6),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Config.yMargin(context, 10)),
                      Text(
                        'Progress',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: Config.textSize(context, 4.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: Config.yMargin(context, 1.0)),
                        child: Text(
                          '${waterTakenDB.progress >= 1 ? '0' : waterTakenDB.totalLevel - waterTakenDB.currentLevel} ml left out of ${waterTakenDB.totalLevel} ml',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: Config.textSize(context, 4),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: Config.yMargin(context, 10)),

              Padding(
                padding: EdgeInsets.only(bottom: Config.yMargin(context, 2.0)),
                child: Container(
                  padding: EdgeInsets.all(Config.xMargin(context, 3.55)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(Config.yMargin(context, 1.28))),
                    color: Theme.of(context).primaryColor,
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: Config.xMargin(context, 5.33),
                      right: Config.xMargin(context, 6)), //24,24,27
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold,
                      fontSize: Config.textSize(context, 4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  // void showSnackBar(BuildContext context) {
  //   SnackBar snackBar = SnackBar(
  //     backgroundColor: Theme.of(context).buttonColor.withOpacity(.9),
  //     duration: Duration(seconds: 2),
  //     content: Text(
  //       'Schedule deleted',
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //           fontSize: Config.textSize(context, 5.3),
  //           color: Theme.of(context).primaryColorLight),
  //     ),
  //   );

  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  void _deleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        WaterNotificationManager waterNotificationManager =
            WaterNotificationManager();
        var waterTakenDB = Provider.of<WaterTakenData>(context, listen: true);
        waterTakenDB.getWaterTaken();
        var waterReminder =
            Provider.of<ScheduleWaterReminderViewModel>(context, listen: true);
        var waterReminderDB =
            Provider.of<WaterReminderData>(context, listen: true);
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Config.xMargin(context, 4.0)),
          ),
          child: Container(
            height: Config.yMargin(context, 20),
            width: Config.xMargin(context, 150.0),
            //width: Config.xMargin(context, 50),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 23.0, bottom: 20.0),
                    child: Text(
                      'Are you sure you want to delete this?',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: Config.yMargin(context, 6.0),
                        width: Config.xMargin(context, 30.0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          color: Theme.of(context).primaryColorLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Config.xMargin(context, 2.0)),
                            side: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.4),
                                width: 1.5),
                          ),
                        ),
                      ),
                      Container(
                        height: Config.yMargin(context, 6.0),
                        width: Config.xMargin(context, 30.0),
                        child: FlatButton(
                          onPressed: () {
                            var diff = widget.water.endTime
                                .difference(widget.water.startTime)
                                .inMinutes;

                            double numb = diff / widget.water.interval;
                            for (var i = 1; i < numb + 1; i++) {
                              var timeValue = widget.water.startTime.add(
                                Duration(
                                    minutes:
                                        i == 1 ? 0 : widget.water.interval * i),
                              );
                              waterNotificationManager.removeReminder(
                                  widget.water.startTime.day +
                                      timeValue.minute +
                                      60);
                            }
                            waterTakenDB.deleteAllWaterTaken();
                            waterReminderDB
                                .deleteWaterReminder(widget.water.id)
                                .then((val) => Navigator.pushNamed(
                                    context, RouteNames.waterScheduleView));
                            // showSnackBar(context);
                            // Future.delayed(Duration(seconds: 1), () {
                            // });
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          color: Theme.of(context).primaryColorLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Config.xMargin(context, 2.0)),
                            side: BorderSide(
                                color:
                                    Theme.of(context).hintColor.withOpacity(.4),
                                width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
