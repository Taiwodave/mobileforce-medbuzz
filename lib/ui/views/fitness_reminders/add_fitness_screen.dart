import 'dart:math';
import 'package:MedBuzz/core/constants/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MedBuzz/core/models/fitness_reminder.dart';
import 'package:MedBuzz/ui/size_config/config.dart';
import 'package:provider/provider.dart';
import '../../../core/database/fitness_reminder.dart';
import '../../../core/models/fitness_reminder.dart';
import '../../../core/models/fitness_reminder_model/fitness_reminder.dart';
import '../../../core/notifications/fitness_notification_manager.dart';
import '../../navigation/app_navigation/app_transition.dart';
import '../../size_config/config.dart';
import 'all_fitness_reminders_screen.dart';

class FitnessEditScreen extends StatelessWidget {
  final FitnessModel fitnessModel;

  const FitnessEditScreen({Key key, this.fitnessModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AddFitness());
  }
}

class AddFitness extends StatefulWidget {
  // final FitnessModel fitnessModel;
  @override
  __AddFitnessState createState() => __AddFitnessState();
}

class __AddFitnessState extends State<AddFitness> {
  // ignore: non_constant_identifier_names
  bool _changed_name = false;

  __AddFitnessState({this.fitnessModel});
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(DiagnosticsProperty<Schedule>('schedule', schedule));
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      //Get updated data from database
      Provider.of<FitnessReminderCRUD>(context).getReminders();
    });
  }

  Navigation navigation = Navigation();
  final List activityType = [
    'images/cycle.png',
    'images/sprint.png',
    'images/swim.png'
  ];
  final List<String> fitnessTime = [
    'Daily',
    'Every 2 days',
    'Every 3 days',
    'Every 4 days'
  ];
  final FitnessModel fitnessModel;

//Instantiating a SizeConfig object to handle responsiveness

  Config config = Config();

  TextEditingController descController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var fitnessDB = Provider.of<FitnessReminderCRUD>(context);
    String appBar = fitnessDB.isEditting ? fitnessDB.edit : fitnessDB.add;

    if (fitnessDB.isEditting && _changed_name == false) {
      descController.text = fitnessModel.desc;
      _changed_name = true;
    }

    FitnessNotificationManager fitnessNotificationManager =
        FitnessNotificationManager();
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    var model = Provider.of<FitnessReminderCRUD>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(appBar,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Theme.of(context).primaryColorDark,
            size: Config.xMargin(context, 8),
          ),
          onPressed: () {
            navigation.pushFrom(context, FitnessSchedulesScreen());
            Navigator.pushReplacementNamed(context, RouteNames.homePage);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, RouteNames.homePage);
          return Future.value(false);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Config.xMargin(context, 5)),
          child: Container(
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ScrollConfiguration(
              // behavior: ScrollBehavior(),
              behavior: ScrollBehavior(),
              child: GestureDetector(
                onTap: () {
                  if (focusNode.hasFocus) {
                    focusNode.unfocus();
                  }
                },
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Select Exercise',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w600,
                          fontSize: Config.xMargin(context, 5)),
                    ),
                    SizedBox(height: Config.yMargin(context, 1.0)),
                    Container(
                      height: Config.yMargin(context, 14),
                      color: Theme.of(context).backgroundColor,
                      child: ListView.builder(
                        padding:
                            EdgeInsets.only(left: Config.xMargin(context, 0)),
                        scrollDirection: Axis.horizontal,
                        itemCount: model.fitnessType.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildImageContainer(index);
                        },
                      ),
                    ),
//
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Config.xMargin(context, 7)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: Config.textSize(context, 5),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: Config.yMargin(context, 1.5)),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,

                            // controller: descriptionTextController,
                            controller: descController,
                            cursorColor: Theme.of(context).primaryColorDark,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: Config.xMargin(context, 5.5)),
                            decoration: InputDecoration(
                              hintText: 'Optional Description...',
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: Config.xMargin(context, 4.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Config.xMargin(context, 5))),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Config.xMargin(context, 5))),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* Text(
                      'Description',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w600,
                          fontSize: Config.xMargin(context, 5)),
                    ),
                    SizedBox(height: Config.yMargin(context, 1.0)),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      focusNode: focusNode,
                      controller: descController,
                      cursorColor: Theme.of(context).primaryColorDark,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: Config.xMargin(context, 5.5)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: Config.yMargin(context, 1.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Config.xMargin(context, 5))),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark),
                        ),

                        hintText: 'Input Description',
                        hintStyle: TextStyle(
                            fontSize: Config.xMargin(context, 5),
                            color: Theme.of(context).hintColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Config.xMargin(context, 5))),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark),
                        ),
//
                      ),
                    ), */
                    SizedBox(height: Config.yMargin(context, 4.5)),
                    Text(
                      'Reminder Frequency',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: Config.xMargin(context, 5.5)),
                    ),
                    SizedBox(height: Config.yMargin(context, 1.0)),

//                      Row(
//                        //crossAxisAlignment: CrossAxisAlignment.,
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
                    //  Expanded(
                    Container(
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius:
                              BorderRadius.all((Radius.circular(6.0))),
                        ),
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                            underline: Text(''),
                            items: fitnessTime.map((String time) {
                              return DropdownMenuItem<String>(
                                  value: time, child: Text(time));
                            }).toList(),
                            value: model.selectedFreq,
                            onChanged: (newFreq) {
                              setState(() {
                                model.selectedFreq = newFreq;
                              });
                            }),
                      ),
                    ),
                    SizedBox(height: Config.xMargin(context, 4.5)),
                    Text(
                      'Set time For Fitness Activity',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w600,
                          fontSize: Config.xMargin(context, 5.0)),
                    ),
                    SizedBox(height: Config.xMargin(context, 4.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                              ),
                              SizedBox(width: Config.xMargin(context, 1.5)),
                              InkWell(
                                focusColor: Theme.of(context).primaryColorLight,
                                splashColor: Theme.of(context).primaryColor,
                                child: Text(
                                  localizations
                                      .formatTimeOfDay(model.activityTime),
                                  style: TextStyle(
                                      fontSize: Config.xMargin(context, 4.2)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Config.xMargin(context, 4.0))),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Config.textSize(context, 4),
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                          onPressed: () {
                            selectTime(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(height: Config.xMargin(context, 4.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            color: Theme.of(context).primaryColor,
                            icon: Icon(
                              Icons.remove_circle,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                model.minDaily--;
                              });
                            }),
                        Text(
                          '${model.minDaily}',
                          style: TextStyle(
                            fontSize: Config.textSize(context, 4),
                          ),
                        ),
                        IconButton(
                            color: Theme.of(context).primaryColor,
                            icon: Icon(
                              Icons.add_circle,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                model.minDaily++;
                              });
                            }),
                      ],
                    ),
                    SizedBox(height: Config.xMargin(context, 4.5)),
                    Text(
                      'Duration',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w600,
                          fontSize: Config.xMargin(context, 5.0)),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Start - ${localizations.formatShortDate(model.startDate)}',
                              style: TextStyle(
                                fontSize: Config.xMargin(context, 4),
                              ),
                            ),
                            SizedBox(width: Config.xMargin(context, 3)),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Config.xMargin(context, 4.0))),
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Config.textSize(context, 4),
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                              onPressed: () {
                                selectStartDate(context);
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'End  -  ${localizations.formatShortDate(model.endDate)}',
                              style: TextStyle(
                                  fontSize: Config.xMargin(context, 4)),
                            ),
                            SizedBox(width: Config.xMargin(context, 3)),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Config.xMargin(context, 4.0))),
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Config.textSize(context, 4),
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                              onPressed: () {
                                selectEndDate(context);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Config.yMargin(context, 5),
                    ),
                    Center(
                      child: Container(
                        height: Config.yMargin(context, 6.5),
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Config.xMargin(context, 3))),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: Config.textSize(context, 5.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //Navigate to home screen after saving details in db
                          onPressed: () async {
                            if (descController.text.isNotEmpty) {
                              switch (appBar) {
                                case 'Add Fitness Reminder':
                                  print('${descController.text}');
                                  FitnessReminder newReminder = FitnessReminder(
                                      id: model.id.toString(),
                                      activityTime: [
                                        model.activityTime.hour,
                                        model.activityTime.minute
                                      ],
                                      endDate: model.endDate,
                                      startDate: model.startDate,
                                      index: model.selectedIndex,
                                      description: model.updateDescription(
                                          descController.text),
                                      minsperday: model.minDaily,
                                      fitnessfreq: model.selectedFreq,
                                      fitnesstype: model
                                          .fitnessType[model.selectedIndex]);
                                  await fitnessDB.addReminder(newReminder);

//                                var difference =
//                                    model.endDate.difference(model.startDate).inHours;
//
//                                if (difference == 0) {
//                                  showSnackBar(context,
//                                      text:
//                                          "Start date should be different from end date");
//                                } else
////                                  {
//////                                 navigation.pushFrom(
//////                                     context, );
////
////                                  fitnessNotificationManager
////                                      .showFitnessNotificationOnce(
////                                          model.id,
////                                          "It's time to go ${descController.text}",
////                                          "For ${model.minDaily} minutes",
////                                          getDateTime());
////                                  print(id);
////                                  _successDialog();
////                                  Future.delayed(Duration(seconds: 2), () {
////                                    Navigator.pushNamed(context,
////                                        RouteNames.fitnessSchedulesScreen);
////                                  });
////                                }
//                              } else {
//                                showSnackBar(context);
                                  break;

//                            ///begining of eedittingi functionality or something like that
//                            case 'Edit Fitness Reminder':
//                              if (descController.text.isNotEmpty) {
//                                print('${descController.text}');
//
//                                var difference =
//                                    model.endDate.difference(model.startDate).inHours;
//
//                                if (difference == 0) {
//                                  showSnackBar(context,
//                                      text:
//                                          "Start date should be different from end date");
//                                } else {
////                                 navigation.pushFrom(
////                                     context, );
//                                  var newReminder = FitnessReminder(
//                                      id: model.id.toString(),
//                                      activityTime: [
//                                        model.activityTime.hour,
//                                        model.activityTime.minute
//                                      ],
//                                      endDate: model.endDate,
//                                      startDate: model.startDate,
//                                      index: model.index,
//                                      description: descController.text,
//                                      minsperday: model.minDaily,
//                                      fitnessfreq: model.selectedFreq,
//                                      fitnesstype:
//                                          model.fitnessType[model.selectedIndex]);
//                                  fitnessDB.editReminder(newReminder);
//    break;
//                                  fitnessNotificationManager.removeReminder(id);
//                                  fitnessNotificationManager
//                                      .showFitnessNotificationOnce(
//                                          id,
//                                          "It's time to go ${descController.text}",
//                                          "For $minDaily minutes",
//                                          getDateTime());
//                                  print(id);

//                                  _successDialog();
//                                  Future.delayed(Duration(seconds: 2), () {
//                                    Navigator.pushNamed(context,
//                                        RouteNames.fitnessSchedulesScreen);
//                                  });

                              }

                              print([
                                model.id,
                                model.fitnessType[model.selectedIndex],
                                model.activityType[model.selectedIndex],
                                model.selectedIndex,
                                model.startDate,
                                model.endDate,
                                model.updateDescription(descController.text),
                                model.activityTime
                              ]);
                              Navigator.popAndPushNamed(
                                  context, RouteNames.fitnessSchedulesScreen);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Config.yMargin(context, 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//  getDateTime() {
//    final now = new DateTime.now();
//    return DateTime(
//        now.year, now.month, now.day, activityTime.hour, activityTime.minute);
//  }

  Future<Null> selectTime(BuildContext context) async {
    var model = Provider.of<FitnessReminderCRUD>(context);
    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: model.activityTime,
    );
    bool today = model.startDate.difference(DateTime.now()) == 0;
    if (today && selectedTime.hour < currentTime.hour) {
      showSnackBar(context, text: "Cannot set reminder in the past");
    } else {
      if (selectedTime != null && selectedTime != model.activityTime) {
        setState(() {
          model.activityTime = selectedTime;
        });
      }
    }
  }

  void showSnackBar(BuildContext context, {String text: 'Enter Valid Time'}) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Theme.of(context).buttonColor.withOpacity(.9),
      duration: Duration(seconds: 2),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: Config.textSize(context, 5.3),
            color: Theme.of(context).primaryColorLight),
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<Null> selectStartDate(BuildContext context) async {
    var model = Provider.of<FitnessReminderCRUD>(context);

    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: model.startDate,
        firstDate: DateTime(model.startDate.year),
        lastDate: DateTime(model.startDate.year + 1));
    if (selectedDate.difference(model.startDate).inDays < 0) {
      showSnackBar(context, text: "Cannot set reminder in the past");
    } else {
      if (selectedDate != null && selectedDate != model.startDate) {
        setState(() {
          model.startDate = selectedDate;
        });

        print('${model.startDate}');
      }
    }
  }

  Future<Null> selectEndDate(BuildContext context) async {
    var model = Provider.of<FitnessReminderCRUD>(context);

    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: model.endDate,
        firstDate: DateTime(model.endDate.year),
        lastDate: DateTime(model.endDate.year + 1));
    if (selectedDate.difference(model.endDate).inDays < 0) {
      showSnackBar(context, text: "Cannot set reminder in the past");
    } else {
      if (selectedDate != null && selectedDate != model.endDate) {
        setState(() {
          model.endDate = selectedDate;
        });

        print('${model.startDate}');
      }
    }
  }

  void _successDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Config.xMargin(context, 8))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('images/check.png'),
              SizedBox(
                height: Config.yMargin(context, 5),
              ),
              Text("Reminder Successfully added!"),
            ],
          ),
        );
      },
    );
  }

  Widget buildImageContainer(int index) {
    var model = Provider.of<FitnessReminderCRUD>(context);

    return GestureDetector(
      onTap: () {
        model.onSelectedFitnessImage(index);
        print(model.updateSelectedIndex(index));
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(Config.xMargin(context, 1.5)),
              margin: EdgeInsets.only(right: Config.xMargin(context, 3)),
              height: Config.yMargin(context, 10),
              width: Config.xMargin(context, 18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: model.selectedIndex == index
                    ? Theme.of(context).primaryColor
                    : Color(0xffFCEDB8),
              ),
              child: Image(
                image: AssetImage(model.activityType[index]),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
              child: Text(
            model.fitnessType[index],
            style: TextStyle(fontSize: 12),
          )),
        ],
      ),
    );
  }
}
