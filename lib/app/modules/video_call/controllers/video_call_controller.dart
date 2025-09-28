import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vcapp/constants/app_constants.dart';

class VideoCallController extends GetxController {
  late RtcEngine engine;
  late VideoViewController localVideoController;

  var remoteUid = RxnInt(); // remote user uid
  var isJoined = false.obs;
  var isMuted = false.obs;
  var isVideoDisabled = false.obs;
  var isScreenSharing = false.obs;

  @override
  void onInit() {
    super.onInit();
    initAgora();
  }

  Future<void> handlePermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  Future<void> initAgora() async {
    await handlePermissions();

    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: AppConstants.appId));

    await engine.enableVideo();
    await engine.startPreview();

    // Local Video Controller
    localVideoController = VideoViewController(
      rtcEngine: engine,
      canvas: const VideoCanvas(uid: 0),
    );

    // Event handlers
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, uid) {
          isJoined.value = true;
          print("Local user $uid joined channel ${connection.channelId}");
        },
        onUserJoined: (connection, uid, elapsed) {
          remoteUid.value = uid; // update remote user
          print("Remote user $uid joined channel ${connection.channelId}");
        },
        onUserOffline: (connection, uid, reason) {
          remoteUid.value = null; // remove remote user
          print("Remote user $uid left channel ${connection.channelId}");
        },
      ),
    );

    // Join channel with Agora assigning UID automatically
    await engine.joinChannel(
      token: AppConstants.tempToken,
      channelId: AppConstants.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    engine.muteLocalAudioStream(isMuted.value);
  }

  void toggleVideo() {
    isVideoDisabled.value = !isVideoDisabled.value;
    engine.muteLocalVideoStream(isVideoDisabled.value);
  }

  Future<void> toggleScreenShare() async {
    if (isScreenSharing.value) {
      await engine.stopScreenCapture();
      isScreenSharing.value = false;
    } else {
      await engine.startScreenCapture(
        ScreenCaptureParameters2(captureAudio: true, captureVideo: true),
      );
      isScreenSharing.value = true;
    }
  }

  @override
  void onClose() {
    engine.leaveChannel();
    engine.release();
    localVideoController.dispose();
    super.onClose();
  }
}
