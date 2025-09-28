import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vcapp/app/data/baseurl.dart';

class ApiService extends GetxService {
  final String baseUrl = BaseUrl.current;
  final RxList<Map<String, dynamic>> apiLogs = <Map<String, dynamic>>[].obs;

  Future<Map<String, String>> _getAuthHeaders({
    Map<String, String>? headers,
    bool? isRefererChange,
  }) async {
    final Map<String, String> authHeaders = {
      'Content-Type': 'application/json',
      'x-api-key': 'reqres-free-v1',
    };

    if (headers != null) {
      authHeaders.addAll(headers);
    }

    return authHeaders;
  }

  Future<dynamic> get(
    String endpoint, {
    bool? isRefererChange,
    bool? isAuthTokenRequired,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    final requestHeaders = await _getAuthHeaders(
      isRefererChange: isRefererChange,
    );
    final response = await http.get(url, headers: requestHeaders);
    return _logAndHandle('GET', url.toString(), null, response, requestHeaders);
  }

  Future<dynamic> post(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    bool? isAuthTokenRequired,
    bool? isRefererChange,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    final requestHeaders = await _getAuthHeaders(
      headers: headers,
      isRefererChange: isRefererChange,
    );
    final response = await http.post(
      url,
      headers: requestHeaders,
      body: json.encode(body),
    );
    return _logAndHandle(
      'POST',
      url.toString(),
      body,
      response,
      requestHeaders,
    );
  }

  dynamic _logAndHandle(
    String method,
    String url,
    dynamic requestBody,
    http.Response response,
    Map<String, String> headers,
  ) {
    final logEntry = {
      'timestamp': DateTime.now().toString(),
      'method': method,
      'url': url,
      'headers': headers,
      'request': requestBody,
      'status': response.statusCode,
      'response': response.body,
    };
    apiLogs.add(logEntry);

    final decoded = response.body != "" ? jsonDecode(response.body) : "";
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResult(statusCode: response.statusCode, data: decoded);
    } else if (response.statusCode == 403) {
      String message = extractErrorMessage(decoded);
      Get.snackbar(
        'Access Denied',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 2),
      );
    } else if (response.statusCode == 401) {
      // refreshToken();
      throw Exception('Forbidden - Redirecting to login');
    } else if (response.statusCode == 400) {
      String message = extractErrorMessage(decoded);
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 2),
      );
    } else if (response.statusCode == 500) {
      String message = extractErrorMessage(decoded);
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 2),
      );
    } else if (response.statusCode == 404) {
      String message = extractErrorMessage(decoded);
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 2),
      );
    }

    return ApiResult(statusCode: response.statusCode, data: decoded);
  }
}

String extractErrorMessage(dynamic error) {
  try {
    if (error == null) {
      return "Something went wrong. Please try again.";
    }

    // If the error is already a string
    if (error is String) return error;

    // If it's a map (decoded JSON)
    if (error is Map) {
      // Recursively extract messages from all keys
      List<String> messages = [];

      error.forEach((key, value) {
        if (value is String) {
          messages.add(value);
        } else if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value is Map) {
          String nested = extractErrorMessage(value);
          if (nested.isNotEmpty) messages.add(nested);
        }
      });

      if (messages.isNotEmpty) {
        return messages.join("\n");
      }
    }

    // If it's a list
    if (error is List) {
      return error.map((e) => extractErrorMessage(e)).join("\n");
    }

    // Fallback
    return "Something went wrong. Please try again.";
  } catch (e) {
    return "Unexpected error occurred.";
  }
}

class ApiResult {
  final int statusCode;
  final dynamic data;

  ApiResult({required this.statusCode, this.data});
}
