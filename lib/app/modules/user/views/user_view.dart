import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_load_more/easy_load_more.dart';
import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), centerTitle: true),
      body: Obx(() {
        if (controller.state.value == UserState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.state.value == UserState.error) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }
        if (controller.state.value == UserState.empty) {
          return const Center(child: Text('No users found'));
        }
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: EasyLoadMore(
            isFinished: !controller.hasMoreData.value,
            onLoadMore: controller.loadMore,
            loadingStatusText: 'Loading more users...',
            finishedStatusText: 'No more users to load',
            failedStatusText: 'Failed to load more users',
            idleStatusText: 'Pull up to load more',
            child: ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Get.defaultDialog(
                      backgroundColor: Colors.white,
                      title: '',
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(user.email),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
