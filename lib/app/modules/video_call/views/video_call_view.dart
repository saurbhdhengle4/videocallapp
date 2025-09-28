import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:vcapp/app/modules/video_call/controllers/video_call_controller.dart';
import 'package:vcapp/constants/app_constants.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Call")),
      body: Obx(() {
        if (!controller.isJoined.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Remote video
            Obx(() {
              final uid = controller.remoteUid.value;
              if (uid != null) {
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.engine,
                    canvas: VideoCanvas(uid: uid),
                    connection: RtcConnection(
                      channelId: AppConstants.channelName,
                    ),
                  ),
                );
              }
              return const Center(child: Text("Waiting for user..."));
            }),

            // Local video preview
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 120,
                height: 160,
                child:
                    controller.isVideoDisabled.value
                        ? Container(
                          color: Colors.black,
                          child: const Icon(
                            Icons.videocam_off,
                            color: Colors.white,
                          ),
                        )
                        : AgoraVideoView(
                          controller: controller.localVideoController,
                        ),
              ),
            ),

            // Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "mute",
                    onPressed: controller.toggleMute,
                    backgroundColor:
                        controller.isMuted.value ? Colors.red : Colors.blue,
                    child: Icon(
                      controller.isMuted.value ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: "video",
                    onPressed: controller.toggleVideo,
                    backgroundColor:
                        controller.isVideoDisabled.value
                            ? Colors.red
                            : Colors.blue,
                    child: Icon(
                      controller.isVideoDisabled.value
                          ? Icons.videocam_off
                          : Icons.videocam,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: "screen",
                    onPressed: controller.toggleScreenShare,
                    backgroundColor:
                        controller.isScreenSharing.value
                            ? Colors.red
                            : Colors.blue,
                    child: Icon(
                      controller.isScreenSharing.value
                          ? Icons.stop_screen_share
                          : Icons.screen_share,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: "end",
                    onPressed: () => Get.back(),
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
