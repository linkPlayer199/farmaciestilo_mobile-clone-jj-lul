import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:farmacie_stilo/util/app_constants.dart';
// import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/screens/schedulig/booked_slots.dart';
import '../view/screens/schedulig/doctor_availability.dart';
import '../view/screens/schedulig/videocall_page.dart';

final sheduleCallProvider = ChangeNotifierProvider(
  (ref) => SheduleCallProvider(),
);
final videoCamCheckProvider = StateProvider((ref) {
  return false;
});
final micheckProvider = StateProvider((ref) {
  return false;
});
// extension dateFormating on DateFormat{
//  englishToItalian(date){
// DateFormat("EEE dd MMM", 'en').parse(date);
//  }

// }
class SheduleCallProvider extends ChangeNotifier {
  Dio dio = Dio();

  // List weekDayList = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List newWeekDayList = [
    '${DateFormat('EEE dd MMM').format(DateTime.now())}',
    '${DateFormat('EEE dd MMM').format(DateTime.now().add(Duration(days: 1)))}',
    '${DateFormat('EEE dd MMM').format(DateTime.now().add(Duration(days: 2)))}',
    '${DateFormat('EEE dd MMM').format(DateTime.now().add(Duration(days: 3)))}',
    '${DateFormat('EEE dd MMM').format(DateTime.now().add(Duration(days: 4)))}',
    '${DateFormat('EEE dd MMM').format(DateTime.now().add(Duration(days: 5)))}',
    '${DateFormat('EEE dd MMM').format(DateTime.now().add(Duration(days: 6)))}'
  ];
  //   List newMonthList = [
  //   '${DateFormat('MMM').format(DateTime.now())}',
  //   '${DateFormat('MMM').format(DateTime.now().add(Duration(days: 1)))}',
  //   '${DateFormat('MMM').format(DateTime.now().add(Duration(days: 2)))}',
  //   '${DateFormat('MMM').format(DateTime.now().add(Duration(days: 3)))}',
  //   '${DateFormat('MMM').format(DateTime.now().add(Duration(days: 4)))}',
  //   '${DateFormat('MMM' ).format(DateTime.now().add(Duration(days: 5)))}',
  //   '${DateFormat('MMM').format(DateTime.now().add(Duration(days: 6)))}'
  // ];
  var daySelected = "";
  var bookedEndTime = '';
  var bookedStartTime = '';
  var adminStatus;
  bool? isPurposeText;

  // List<Slot> getSlot = [];
  var load = false;
  // List timeList = [
  //   '01:00 - 01:30',
  //   '01:30 - 02:00',
  //   '02:00 - 02:30',
  //   '02:30 - 03:00',
  //   '03:00 - 03:30',
  //   '03:30 - 04:00',
  //   '04:00 - 04:30',
  //   '04:30 - 05:00',
  //   '05:00 - 05:30',
  //   '05:30 - 06:00',
  //   '06:00 - 06:30',
  //   '06:30 - 07:00',
  //   '07:00 - 07:30',
  //   '07:30 - 08:00',
  //   '08:00 - 08:30',
  //   '08:30 - 09:00',
  //   '09:00 - 09:30',
  //   '09:30 - 10:00',
  //   '10:00 - 10:30',
  //   '10:30 - 11:00',
  //   '11:00 - 11:30',
  //   '11:30 - 12:00',
  //   '12:00 - 12:30',
  //   '12:30 - 13:00',
  //   '13:00 - 13:30',
  //   '13:30 - 14:00',
  //   '14:00 - 14:30',
  //   '14:30 - 15:00',
  //   '15:00 - 15:30',
  //   '15:30 - 16:00',
  //   '16:00 - 16:30',
  //   '16:30 - 17:00',
  //   '17:00 - 17:30',
  //   '17:30 - 18:00',
  //   '18:00 - 18:30',
  //   '18:30 - 19:00',
  //   '19:00 - 19:30',
  //   '19:30 - 20:00',
  //   '20:00 - 20:30',
  //   '20:30 - 21:00',
  //   '21:00 - 21:30',
  //   '21:30 - 22:00',
  //   '22:00 - 22:30',
  //   '22:30 - 23:00',
  //   '23:00 - 23:30',
  //   '23:30 - 24:00',
  //   '24:00 - 24:30',
  //   '24:30 - 00:00',
  //   '00:00 - 00:30',
  //   '00:30 - 01:00',
  // ];

  // List selected = [
  //   true,
  //   false,
  //   true,
  //   true,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  // ];

  // NewGetSlotModel? allSlots;
  bool isApiLoading = false;
  // List<AvailableSlots> available = [];
  // List<AvailableSlots>slots = [];

  getCall(context, {required WidgetRef ref}) async {
    isApiLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("user_id");
    // var userID = '4101';
    Map<String, dynamic> data = {'user_id': userID};

    final response =
        await dio.post("${AppConstants.BASE_URL_NEW}get_call/1", data: data);
    try {
      if (response.statusCode == 200) {
        var message = response.data;
     if (message['message'] == "Call joined successfully") {
          isApiLoading = false;
          notifyListeners();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoView(
                  token: message['token'],
                ),
              ));
        } else {
          isApiLoading = false;
          notifyListeners();
          await getAllSlots(context,
              '${DateFormat('EEE dd MMM').format(DateTime.now())}', true);
        }
      } else {
        return;
      }
    } on DioException catch (e) {
      print(e);
    }

    notifyListeners();
  }

  getAdminStatus(context) async {
    final response = await dio.get(
      "${AppConstants.BASE_URL_NEW}status",
    );

    try {
      if (response.statusCode == 200) {
        adminStatus = response.data["data"]["value"];
        notifyListeners();
        Navigator.pushNamed(context, DoctorAvailability.routeName);

        print(adminStatus);
      } else {
        print("error");
      }
    } on DioException catch (e) {
      print(e);
    }
  }

  // String fullDay(daySelected) {
  //   switch (daySelected) {
  //     case 'Mon':
  //       return 'monday';
  //     case 'Tue':
  //       return 'tuesday';
  //     case 'Wed':
  //       return 'wednesday';
  //     case 'Thu':
  //       return 'thursday';
  //     case 'Fri':
  //       return 'friday';
  //     case 'Sat':
  //       return 'saturday';
  //     case 'Sun':
  //       return 'sunday';
  //     default:
  //       return '';
  //   }
  // }

  // getAllSlots(context) async {
  //   final response = await _apisNew.getAllSlots();
  //   try {
  //     if (response.statusCode == 200) {
  //       slots.clear();

  //       slots.addAll(response.data
  //           .map<AvailableSlots>((e) => AvailableSlots.fromJson(e))
  //           .toList());

  //       Navigator.pushNamed(context, DoctorTimeAvailibility.routeName,
  //           arguments: slots);
  //       return;
  //     } else {
  //       return;
  //     }
  //   } on DioError catch (e) {
  //     print(e);
  //   }
  // }
  // List<String> dateTime = [];
  List<dynamic> listBookSlot = [];
  List<dynamic> responseSlots = [];
  List<dynamic> ssList = [];
  List<dynamic> responseBooked = [];
  String lang = '';
  getAllSlots(context, String daySelected, bool isRoute) async {
    load = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
 var userID = prefs.getInt("user_id");
    // var userID = '4101';

    // var englishDate;
    // if (lang.contains("it")) {
    //   var conDate = DateFormat("EEE dd MMM", 'it').parse(daySelected);
    //   englishDate = DateFormat("EEE dd MMM", 'en')
    //       .format(DateTime(DateTime.now().year, conDate.month, conDate.day))
    //       .toString();
    //   log(englishDate);
    // }

    ssList.clear();
    responseSlots.clear();
    responseBooked.clear();

    final response = await dio.get(
      "${AppConstants.BASE_URL_NEW}slots/${daySelected}",
    );


    try {
      if (response.statusCode == 200) {
        responseSlots = response.data['slots'];
        responseBooked = response.data['booked'];
        ssList.addAll(responseSlots);
        for (Map i in ssList) {
          for (Map j in responseBooked) {
            if (i['id'].toString() == j['slot_id']) {
              i['book'] = true;
              i['currentUser'] = false;
              if (j.containsValue(userID)) {
                i['book'] = true;
                i['currentUser'] = true;
              }
            } else if (!i.containsKey('book')) {
              i['book'] = false;
              i['currentUser'] = false;
            }
          }
          if (!i.containsKey('book')) {
            i['book'] = false;
            i['currentUser'] = false;
          }
          // log("$ssList");
        }
        load = false;
        notifyListeners();
        isRoute == true
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorTimeAvailibility(),
                ))
            : null;
      } else {
        load = false;

        notifyListeners();
       //showInSnackBar('got some error', context);
      }
    } on DioError catch (e) {
      load = false;
      notifyListeners();
      // showInSnackBar('got some error', context);
    }
  }

  // localBookSlot(List<String>? dateTime) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList('dateTime', dateTime!);
  // }

  // localCancelSlot(String value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   dateTime = prefs.getStringList('dateTime')!;
  //   dateTime.remove(value);
  //   prefs.setStringList("dateTime", dateTime);
  // }

  // localGetSlot() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   dateTime = prefs.getStringList('dateTime')!;
  // }

  bookedSlot(context,
      {required WidgetRef ref,
      required String purpose,
      required int slotId,
      required bookedDate}) async {
    load = true;
    notifyListeners();
    // final user = ref.read(authProvider).user;
    // var englishDate = DateFormat("EEE dd MMM", 'it').parse(bookedDate);
    final prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("user_id");
    Map<String, dynamic> data = {
      "slot_id": slotId,
      // "date": DateFormat("EEE dd MMM", 'en').format(englishDate).toString(),
      "date": bookedDate,
      "user_id": userID,
      "email": 'jj@gmail.com',
      "name": "jj",
      "subject": purpose
    };
    final response =
        await dio.post("${AppConstants.BASE_URL_NEW}booked", data: data);
    try {
      if (response.statusCode == 200) {
        var message = response.data;
        await getAllSlots(context, daySelected, false);

        print(message['message']);
      } else {
        load = false;
        print("error");
      }
    } on DioException catch (e) {
      load = false;
      // showInSnackBar('got some error', context);
    }
  }

  cancelCallApi() async {
    final prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("user_id");
    Map<String, dynamic> data = {'user_id': userID};
    final response =
        await dio.post("${AppConstants.BASE_URL_NEW}end_call/1", data: data);
    if (response.data["message"] == "Call ended successfully") {
      return;
    } else {
      print('error');
    }
  }
  // newGetAllSlots(context) async {
  //   final response = await _apisNew.newGetSlots();
  //   try {
  //     if (response.statusCode == 200) {
  //       slots.clear();

  //       slots.addAll(response.data
  //           .map<NewGetAllSlotModel>((e) => NewGetAllSlotModel.fromJson(e))
  //           .toList());

  //       Navigator.pushNamed(context, DoctorTimeAvailibility.routeName,
  //          );
  //       return;
  //     } else {
  //       return;
  //     }
  //   } on DioError catch (e) {
  //     print(e);
  //   }
  // }
  // newBookedSlot(context, {required WidgetRef ref, required String purpose }) async {
  //   load = true;
  //   notifyListeners();
  //   final user = ref.read(authProvider).user;
  //   Map<String, dynamic> data = {
  //     'date': daySelected,
  //     'time': timeSelected,
  //     'user_id': user?.userId.toString(),
  //     'name':"${user?.firstName} ${user?.lastName}",
  //     'email':user?.email.toString(),
  //     'subject' :purpose
  //   };
  //   final response = await _apisNew.newBookedSlots(data);
  //   try {
  //     if (response.statusCode == 200) {
  //       var message = response.data;
  //       print(message);
  //       final responseAll = await _apisNew.newGetSlots();
  //       try {
  //         if (responseAll.statusCode == 200) {
  //           slots.clear();

  //           slots.addAll(responseAll.data
  //               .map<NewGetAllSlotModel>((e) => NewGetAllSlotModel.fromJson(e))
  //               .toList());
  //           ref.read(sheduleCallProvider).available.clear();
  //        ref.read(sheduleCallProvider).   available.addAll(slots.where((element) =>element.date==
  //                                           ref
  //                                               .watch(
  //                                                  sheduleCallProvider)
  //                                               .daySelected));
  //                                               print(available);
  //           load = false;
  //           notifyListeners();
  //           return;
  //         } else {
  //           load = false;
  //           return;
  //         }
  //       } on DioError catch (e) {
  //         load = false;
  //         print(e);
  //       }
  //       print(message['message']);
  //     } else {
  //       load = false;
  //       print("error");
  //     }
  //   } on DioError catch (e) {
  //     load = false;
  //     print(e);
  //   }
  // }

  cancelSlot(context, {required WidgetRef ref, required int index}) async {
    load = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("user_id");

    // var lang = prefs.getString('language');
    // var englishDate;
    // if (lang!.contains("it")) {
    //   var conDate = DateFormat("EEE dd MMM", 'it').parse(daySelected);
    //   englishDate = DateFormat("EEE dd MMM", 'en')
    //       .format(DateTime(DateTime.now().year, conDate.month, conDate.day))
    //       .toString();
    //   log(englishDate);
    // }
    // var englishDate = DateFormat("EEE dd MMM", 'it').parse(daySelected);

    Map<String, dynamic> data = {
      "user_id": userID,
      "slot_id": ref.watch(sheduleCallProvider).ssList[index]['id'],
      "date": daySelected
      // "date": ref.read(sheduleCallProvider).daySelected
    };
    final response =
        await dio.post("${AppConstants.BASE_URL_NEW}cancel", data: data);
    try {
      if (response.statusCode == 200) {
        var message = response.data;

        print(message['message']);
        ref.watch(sheduleCallProvider).getAllSlots(context, daySelected, false);
      } else {
        load = false;
        notifyListeners();
        print("error");
      }
    } on DioException catch (e) {
      load = false;
      print(e);
    }
  }

  // void initialDaySelected(
  //   WidgetRef ref,
  // ) {
  //   ref.watch(sheduleCallProvider).available.clear();
  //   ref.read(sheduleCallProvider).daySelected =
  //       DateFormat("EEE").format(DateTime.now());
  //   ref.watch(sheduleCallProvider).available.addAll(slots.where((element) {
  //     // print(element.day);
  //     return element.day.name == ref.watch(sheduleCallProvider).daySelected;
  //   }));
  // }
}
