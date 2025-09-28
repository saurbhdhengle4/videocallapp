import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:vcapp/app/data/api_call_service.dart';
import 'package:vcapp/app/data/models/user_model.dart';
import 'package:vcapp/app/data/urls_end_point.dart';

enum UserState { loading, loaded, error, empty }

class UserController extends GetxController {
  RxList<User> users = <User>[].obs;

  final ApiService _apiService = Get.find<ApiService>();

  RxInt page = 1.obs;
  Rx<UserState> state = UserState.loading.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxString errorMessage = ''.obs;

  static const _cacheKey = 'cachedUsers';

  @override
  void onInit() {
    super.onInit();
    loadCachedUsers();
    fetchUsers(isRefresh: true);
  }

  Future<void> loadCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString(_cacheKey);
    if (cachedString != null) {
      try {
        final cachedJson = json.decode(cachedString);
        final cachedModel = UserModel.fromJson(cachedJson);
        users.value = cachedModel.data;
        state.value = users.isEmpty ? UserState.empty : UserState.loaded;
      } finally {}
    }
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        page.value = 1;
        hasMoreData.value = true;
        state.value = UserState.loading;
      }

      final ApiResult apiResult = await _apiService.get(
        APIEndPoints.userList(page: page.value),
        isRefererChange: true,
      );

      if (apiResult.data != null) {
        final response = UserModel.fromJson(
          Map<String, dynamic>.from(apiResult.data as Map),
        );

        if (isRefresh) {
          users.clear();
        }

        if (response.data.isNotEmpty) {
          users.addAll(response.data);
          await _cacheUsers(response);
          hasMoreData.value = page.value < response.totalPages;
          state.value = users.isEmpty ? UserState.empty : UserState.loaded;

          if (!isRefresh) page.value++;
        } else {
          if (page.value == 1) state.value = UserState.empty;
          hasMoreData.value = false;
        }
      } else {
        if (page.value == 1) {
          state.value = UserState.error;
          errorMessage.value = 'Failed to load users';
        }
        hasMoreData.value = false;
      }
    } catch (e) {
      if (page.value == 1 && users.isEmpty) {
        state.value = UserState.error;
        errorMessage.value = e.toString();
      }
      state.value = UserState.loaded;
      Get.snackbar(
        'No Internet',
        'Please check your connection',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
      );
      hasMoreData.value = false;
    }
  }

  Future<void> _cacheUsers(UserModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, json.encode(model.toJson()));
  }

  Future<bool> loadMore() async {
    if (!hasMoreData.value || isLoadingMore.value) return false;
    try {
      isLoadingMore.value = true;
      await fetchUsers(isRefresh: false);
      return true;
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchUsers(isRefresh: true);
  }

  void retry() {
    fetchUsers(isRefresh: true);
  }
}
