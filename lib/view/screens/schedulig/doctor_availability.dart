import 'package:farmacie_stilo/util/images.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../../controller/scheduling_provider.dart';
import '../../base/custom_button.dart';

class DoctorAvailability extends ConsumerStatefulWidget {
  const DoctorAvailability({Key? key}) : super(key: key);
  static const routeName = '/doctorAvailability';

  @override
  ConsumerState<DoctorAvailability> createState() => _DoctorAvailability();
}

class _DoctorAvailability extends ConsumerState<DoctorAvailability>
    with WidgetsBindingObserver {
  @override
  void initState() {
    permissions();
    super.initState();
  }

  permissions() async {
    await Permission.microphone.status == PermissionStatus.granted
        ? ref.read(micheckProvider.notifier).state = true
        : ref.read(micheckProvider.notifier).state = false;
    await Permission.camera.status == PermissionStatus.granted
        ? ref.read(videoCamCheckProvider.notifier).state = true
        : ref.read(micheckProvider.notifier).state = false;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              //color: Colors.green,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 35, right: 25, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              // translate(
                              //   context,
                              //   "Doctor is ? "available Now" : "Not available"}",
                              // ),
                              ref.watch(sheduleCallProvider).adminStatus == 1
                                  ? "doctor_is_available_now".tr
                                  : "doctor_is_not_available".tr,
                              style: const TextStyle(
                                  fontSize: 30,fontWeight: FontWeight.bold,
                                  color: Color(0xFF039D55)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 100,
                              child: Image.asset('assets/image/logossx.png')
                              // child: Image.asset(Images.videoCamIcon)
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: FittedBox(
                              child: Text(
                                'Stilo Live',
                                // 'stilo_chat_wants_to'.tr,
                                style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Color(0xFF039D55)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.mic),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          'use_your_microphone'.tr,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                   // height: 20,
                                    child: Checkbox(
                                      value: ref.watch(micheckProvider),
                                      onChanged: (value) async {
                                        if (value == true) {
                                          if (await Permission.microphone
                                              .request()
                                              .isGranted) {
                                            ref
                                                .read(
                                                    micheckProvider.notifier)
                                                .state = value!;
                                          } else if (await Permission
                                              .microphone.isDenied) {
                                            ref
                                                .read(
                                                    micheckProvider.notifier)
                                                .state = false;
                                          } else {
                                            openAppSettings();
                                          }
                                        } else {
                                          openAppSettings();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.videocam_rounded),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'use_your_videocam'.tr,
                                        style:
                                            const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Checkbox(
                                    value: ref.watch(videoCamCheckProvider),
                                    onChanged: (value) async {
                                      if (value == true) {
                                        if (await Permission.camera
                                            .request()
                                            .isGranted) {
                                          ref
                                              .read(videoCamCheckProvider
                                                  .notifier)
                                              .state = value!;
                                        } else if (await Permission
                                            .camera.isDenied) {
                                          ref
                                              .read(videoCamCheckProvider
                                                  .notifier)
                                              .state = false;
                                        } else {
                                          openAppSettings();
                                        }
                                      } else {
                                        openAppSettings();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   width: 200,
                          //   child: CustomButton(
                          //       buttonText: 'join_now'.tr,
                          //       height: 40,
                          //       onPressed: () async {
                          //         ref
                          //             .read(sheduleCallProvider.notifier)
                          //             .isApiLoading = true;
                          //         // if (false) {
                          //         //   showDialog<String>(
                          //         //     context: context,
                          //         //     builder: (BuildContext context) =>
                          //         //         AlertDialog(
                          //         //       title: Icon(
                          //         //         Icons.lock_outline_rounded,
                          //         //         size: 100,
                          //         //         color: ref
                          //         //             .read(flavorProvider)
                          //         //             .lightPrimary,
                          //         //       ),
                          //         //       content: const Text(
                          //         //           'Please Login For Video Calling'),
                          //         //       actions: <Widget>[
                          //         //         // TextButton(
                          //         //         //   onPressed: () => Navigator.pop(context, 'Cancel'),
                          //         //         //   child: const Text('Cancel'),
                          //         //         // ),
                          //         //         TextButton(
                          //         //           onPressed: () {
                          //         //             Navigator.of(context)
                          //         //                 .pushNamedAndRemoveUntil(
                          //         //                     PreLoginScreen.routeName,
                          //         //                     (route) => false);
                          //         //           },
                          //         //           child: const Text('Go to Login'),
                          //         //         ),
                          //         //       ],
                          //         //     ),
                          //         //   );
                          //         // }
                          //         if (ref.watch(micheckProvider) == false ||
                          //             ref.watch(videoCamCheckProvider) ==
                          //                 false) {
                          //           if (ref.watch(micheckProvider) == false) {
                          //             if (await Permission.microphone
                          //                 .request()
                          //                 .isGranted) {
                          //               ref
                          //                   .read(micheckProvider.notifier)
                          //                   .state = true;
                          //             } else if (await Permission
                          //                 .microphone.isDenied) {
                          //               ref
                          //                   .read(micheckProvider.notifier)
                          //                   .state = false;
                          //             } else {
                          //               openAppSettings();
                          //             }
                          //           }
                          //           if (ref.watch(videoCamCheckProvider) ==
                          //               false) {
                          //             if (await Permission.camera
                          //                 .request()
                          //                 .isGranted) {
                          //               ref
                          //                   .read(
                          //                   videoCamCheckProvider.notifier)
                          //                   .state = true;
                          //             } else if (await Permission
                          //                 .camera.isDenied) {
                          //               ref
                          //                   .read(
                          //                   videoCamCheckProvider.notifier)
                          //                   .state = false;
                          //             } else {
                          //               openAppSettings();
                          //             }
                          //           }
                          //         } else {
                          //           ref
                          //               .read(sheduleCallProvider.notifier)
                          //               .isApiLoading = false;
                          //           ref
                          //               .read(sheduleCallProvider)
                          //               .getCall(context, ref: ref);
                          //         }
                          //       }
                          //       ),
                          // ),
                          const SizedBox(
                            height: 50,
                          ),
                          ref.watch(sheduleCallProvider).isApiLoading == true
                              ? const CircularProgressIndicator(
                                  // color: ref.read(flavorProvider).lightPrimary,
                                  )
                              : customElevatedButton(
                                  'join_now'.tr,
                                  ref.watch(sheduleCallProvider).adminStatus !=
                                          1
                                      ? Color(0xFF039D55)
                                      : Colors.green.shade200,
                                  // adminStatus: ref
                                  //             .watch(sheduleCallProvider)
                                  //             .adminStatus !=
                                  //         1
                                  //     ?
                                  onPressed: () async {

                                  ref
                                      .read(sheduleCallProvider.notifier)
                                      .isApiLoading = true;
                                  // if (false) {
                                  //   showDialog<String>(
                                  //     context: context,
                                  //     builder: (BuildContext context) =>
                                  //         AlertDialog(
                                  //       title: Icon(
                                  //         Icons.lock_outline_rounded,
                                  //         size: 100,
                                  //         color: ref
                                  //             .read(flavorProvider)
                                  //             .lightPrimary,
                                  //       ),
                                  //       content: const Text(
                                  //           'Please Login For Video Calling'),
                                  //       actions: <Widget>[
                                  //         // TextButton(
                                  //         //   onPressed: () => Navigator.pop(context, 'Cancel'),
                                  //         //   child: const Text('Cancel'),
                                  //         // ),
                                  //         TextButton(
                                  //           onPressed: () {
                                  //             Navigator.of(context)
                                  //                 .pushNamedAndRemoveUntil(
                                  //                     PreLoginScreen.routeName,
                                  //                     (route) => false);
                                  //           },
                                  //           child: const Text('Go to Login'),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   );
                                  // }
                                  if (ref.watch(micheckProvider) == false ||
                                      ref.watch(videoCamCheckProvider) ==
                                          false) {
                                    if (ref.watch(micheckProvider) == false) {
                                      if (await Permission.microphone
                                          .request()
                                          .isGranted) {
                                        ref
                                            .read(micheckProvider.notifier)
                                            .state = true;
                                      } else if (await Permission
                                          .microphone.isDenied) {
                                        ref
                                            .read(micheckProvider.notifier)
                                            .state = false;
                                      } else {
                                        openAppSettings();
                                      }
                                    }
                                    if (ref.watch(videoCamCheckProvider) ==
                                        false) {
                                      if (await Permission.camera
                                          .request()
                                          .isGranted) {
                                        ref
                                            .read(
                                                videoCamCheckProvider.notifier)
                                            .state = true;
                                      } else if (await Permission
                                          .camera.isDenied) {
                                        ref
                                            .read(
                                                videoCamCheckProvider.notifier)
                                            .state = false;
                                      } else {
                                        openAppSettings();
                                      }
                                    }
                                  } else {
                                    ref
                                        .read(sheduleCallProvider.notifier)
                                        .isApiLoading = false;
                                    ref
                                        .read(sheduleCallProvider)
                                        .getCall(context, ref: ref);
                                  }
                                }
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          ref.watch(sheduleCallProvider).load == true
                              ? const CircularProgressIndicator(
                                  // color: ref.read(flavorProvider).lightPrimary,
                                  )
                              : customElevatedButton('shedule'.tr, Color(0xFF039D55),
                                  onPressed: () async {
                                  // if (userId == '') {
                                  //   showDialog<String>(
                                  //     context: context,
                                  //     builder: (BuildContext context) =>
                                  //         AlertDialog(
                                  //       title: Icon(
                                  //         Icons.lock_outline_rounded,
                                  //         size: 100,
                                  //         color: ref
                                  //             .read(flavorProvider)
                                  //             .lightPrimary,
                                  //       ),
                                  //       content: const Text(
                                  //           'Please Login For Video Calling'),
                                  //       actions: <Widget>[
                                  //         // TextButton(
                                  //         //   onPressed: () => Navigator.pop(context, 'Cancel'),
                                  //         //   child: const Text('Cancel'),
                                  //         // ),
                                  //         TextButton(
                                  //           onPressed: () {
                                  //             Navigator.of(context)
                                  //                 .pushNamedAndRemoveUntil(
                                  //                     PreLoginScreen.routeName,
                                  //                     (route) => false);
                                  //           },
                                  //           child: const Text('Go to Login'),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   );
                                  // } else {
                                  ref.watch(sheduleCallProvider).notifyListeners();
                                  await ref
                                      .read(sheduleCallProvider)
                                      .getAllSlots(
                                          context,
                                          "${DateFormat(
                                            'EEE dd MMM',
                                          ).format(DateTime.now())}",
                                          true);
                                  // }
                                }),
                          const SizedBox(
                            height: 20,
                          ),
                          customElevatedButton(
                              'sheduling_cancel'.tr, Colors.red, onPressed: () {
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

Container customElevatedButton(String text, Color btnColor,
    {onPressed, adminStatus}) {
  return Container(
    height: 40,
    width: 200,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      onPressed: adminStatus ?? onPressed,
      child: FittedBox(
        child: Text(
          text,
          style: const TextStyle(fontSize: 25),
        ),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    ),
  );
}
