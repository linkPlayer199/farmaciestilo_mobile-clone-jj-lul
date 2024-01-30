import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/scheduling_provider.dart';
import '../../../util/images.dart';

// const appId = "8e522f6bbcd2418abfd8ac0eb2d8f396";

enum VideoOn { videoEnable, videoDisable }

enum MicOn { micEnable, micDisable }

class VideoView extends ConsumerStatefulWidget {
  VideoView({Key? key, required this.token}) : super(key: key);
  final String token;
  @override
  ConsumerState<VideoView> createState() => _VideoView();
}

class _VideoView extends ConsumerState<VideoView> with WidgetsBindingObserver {
  var videoEnum = VideoOn.videoEnable;
  var micEnum = MicOn.micEnable;
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  String generatedToken = '';
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      getStatus(false);
      return;
    } else if (state == AppLifecycleState.resumed) {
      getStatus(true);
    }
  }

  void getStatus(bool status) async {
    if (status == true) {
      log("get call api called");
      await ref.read(sheduleCallProvider).getCall(context, ref: ref);
    } else {
      _engine.leaveChannel();
      _engine.release();
      log("cancel api called");
      await ref.read(sheduleCallProvider).cancelCallApi();
    }
  }

  @override
  void initState() {
    initAgora(widget.token);
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }
  // Future<void> _getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var userID = prefs.getString("user_id");
  //   print('8q2347689072390-546');
  //   print(userID);
  //   print('8q2347689072390-546');
  //   final response = await http.get(
  //       Uri.parse('https://stagapp.contactapharmacy.it/api/get_token/$userID'));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     setState(() {
  //       _token = data['token'];
  //     });
  //   } else {
  //     throw Exception('Failed to retrieve token from API');
  //   }
  // }

  Future<void> initAgora(token) async {
    // retrieve permissions

    //create the engine
    _engine = createAgoraRtcEngine();

    await _engine.initialize(const RtcEngineContext(
      appId: 'ad03cbc3de4c4a76be6e4c52d9ac2638',
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    // _engine.renewToken(AgoraViodeoConst.chanelToken);

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onLeaveChannel: (connection, stats) {
          debugPrint("remote user $stats left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token.toString(),
      channelId: 'stilo',
      // info: '',
      uid: 5, options: const ChannelMediaOptions(),
    );
    // print(AgoraViodeoConst.chanelToken);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("cancel api called");
        await _engine.leaveChannel();
        await _engine.release();

        log("cancel api called");

        ref.read(sheduleCallProvider).cancelCallApi();

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Telemedicine",
            style: TextStyle(color: Colors.black),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 5, top: 10),
          //     child: InkWell(
          //         onTap: () {
          //           // Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(
          //           //       builder: (context) => ScheduleMeetingScreen()),
          //           // );
          //           Navigator.pushNamed(context, DoctorAvailability.routeName);
          //         },
          //         child: const Text('Schedule',
          //             style: TextStyle(color: Colors.black))),
          //   )
          // ],
        ),
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VideoButtonWidgets(
                    color: Colors.green,
                    icon:
                        micEnum == MicOn.micEnable ? Icons.mic_off : Icons.mic,
                    onPreesed: () async {
                      setState(() {});
                      if (micEnum == MicOn.micEnable) {
                        micEnum = MicOn.micDisable;
                        await _engine.pauseAudio();
                      } else {
                        micEnum = MicOn.micEnable;
                        await _engine.resumeAudio();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  VideoButtonWidgets(
                    color: Colors.green,
                    icon: videoEnum == VideoOn.videoDisable
                        ? Icons.video_call_outlined
                        : Icons.videocam_off_outlined,
                    onPreesed: () async {
                      setState(() {});
                      if (videoEnum == VideoOn.videoEnable) {
                        videoEnum = VideoOn.videoDisable;
                        await _engine.disableVideo();
                      } else {
                        videoEnum = VideoOn.videoEnable;
                        await _engine.enableVideo();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  VideoButtonWidgets(
                    color: Colors.green,
                    icon: Icons.switch_camera,
                    onPreesed: () async {
                      await _engine.switchCamera();
                    },
                  ),
                  const SizedBoxWidget(),
                  VideoButtonWidgets(
                    color: Colors.red,
                    icon: Icons.call_end,
                    onPreesed: () async {
                      log("cancel api called");
                      Navigator.pop(context);
                      ref.watch(sheduleCallProvider).cancelCallApi();
                      await _engine.leaveChannel();
                      await _engine.release();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    var size = MediaQuery.of(context).size;
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: 'pharmacy_app'),
        ),
      );
    } else {
      return SizedBox(
          width: size.width * 0.5,
          height: size.height * 0.5,
          child: Image.asset(Images.logoBackGround));
    }
  }
}

class SizedBoxWidget extends StatelessWidget {
  const SizedBoxWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SizedBox(
        width: 10,
      ),
    );
  }
}

class VideoButtonWidgets extends StatelessWidget {
  VideoButtonWidgets(
      {Key? key,
      required this.color,
      required this.icon,
      required this.onPreesed})
      : super(key: key);
  Color color;
  var onPreesed;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      height: 50,
      width: 50,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: onPreesed,
      ),
    );
  }
}





// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// class VideoCallPage extends StatefulWidget {
//   const VideoCallPage({Key? key}) : super(key: key);

//   static const routeName = '/video-call-page';

//   @override
//   State<VideoCallPage> createState() => _VideoCallPageState();
// }

// class _VideoCallPageState extends State<VideoCallPage> {
//   // Instantiate the client
//   final AgoraClient client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//         appId: "36b05f7575a9449daa4d779180ac0950",
//         channelName: "test",
//         tempToken:
//             "007eJxTYNiVdHFdpt6SugWs8lej+cLUXBarqKnJKskKSXc1aP6vM1ZgMDZLMjBNMzc1N020NDGxTElMNEkxN7c0tDBITDawNDU4/XdmckMgI8Pu58uZGRkgEMRnYShJLS5hYAAAJ9Eciw=="),
//   );

// // Initialize the Agora Engine
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   void initAgora() async {
//     await client.initialize();
//   }

// // Build your layout
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(client: client),
//               AgoraVideoButtons(client: client),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
