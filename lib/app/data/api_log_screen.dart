import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vcapp/app/data/api_call_service.dart';

class ApiLogScreen extends StatelessWidget {
  ApiLogScreen({super.key});
  final ApiService apiService = Get.find<ApiService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Logs", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              apiService.apiLogs.clear();
            },
          ),
        ],
      ),
      body: Obx(() {
        final logs = apiService.apiLogs.reversed.toList();
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            final requestText = '''
Time: ${log['timestamp']}
Request Body: ${_prettyPrintJson(log['request'])}
Headers: ${_prettyPrintJson(log['headers'])}
            ''';

            final responseText = '''
Response: ${_prettyPrintJson(log['response'])}
            ''';

            return ExpansionTile(
              title: Text(
                "${log['method']} ${log['url']}",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "Status: ${log['status']}",
                style: TextStyle(
                  color: const Color.fromARGB(255, 136, 63, 181),
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                _buildCopyableSection(requestText, Colors.blue),
                _buildCopyableSection(responseText, Colors.green),
              ],
            );
          },
        );
      }),
    );
  }

  /// ✅ Helper Widget for reusable Copy+SelectableText
  Widget _buildCopyableSection(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// The text content
          Expanded(
            child: SelectableText(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          /// Copy button
          IconButton(
            icon: Icon(Icons.copy, size: 18, color: Colors.grey[700]),
            tooltip: "Copy",
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Get.snackbar(
                "Copied",
                "Text copied to clipboard",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.grey,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MultiTapTrigger extends StatefulWidget {
  final Widget child;
  final int tapThreshold;
  final VoidCallback onTrigger;

  const MultiTapTrigger({
    super.key,
    required this.child,
    required this.onTrigger,
    this.tapThreshold = 10,
  });

  @override
  _MultiTapTriggerState createState() => _MultiTapTriggerState();
}

class _MultiTapTriggerState extends State<MultiTapTrigger> {
  int tapCount = 0;

  void _handleTap() {
    tapCount++;
    if (tapCount >= widget.tapThreshold) {
      tapCount = 0;
      widget.onTrigger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: _handleTap, child: widget.child);
  }
}

String _prettyPrintJson(dynamic jsonData) {
  try {
    if (jsonData is String) {
      final decoded = json.decode(jsonData);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } else if (jsonData is Map || jsonData is List) {
      return const JsonEncoder.withIndent('  ').convert(jsonData);
    } else {
      return jsonData.toString();
    }
  } catch (e) {
    return jsonData.toString();
  }
}
