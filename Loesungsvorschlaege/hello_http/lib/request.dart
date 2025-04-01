import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class CustomResponseData {
  String? date;
  String? deviceName;

  CustomResponseData({required this.date, required this.deviceName});
}

class RequestManager {
  // this value indicates whether the request has to be throttled for debugging reasons
  // this allows to test the loading indicator
  final bool _throttleRequest = true;

  /// Request a response from the HTTP Bin endpoint
  Future<CustomResponseData> fetchResponse() async {
    if (_throttleRequest) {
      await _timeout();
    }

    final deviceName = await _getDeviceName();
    final response = await http.post(Uri.parse('https://httpbin.org/post'),
        body: jsonEncode(<String, String>{
          'deviceName': deviceName ?? 'not identified',
          'date': DateTime.now().toIso8601String()
        }));

    // only status codes between 200 and 300 are accepted so handle that
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> json = _parseResponse(response.body);

      return CustomResponseData(
          date: json['date'], deviceName: json['deviceName']);
    } else {
      throw Exception('There was an error');
    }
  }

  /// Parses the response from HTTP Bin
  Map<String, dynamic> _parseResponse(String body) {
    final Map<String, dynamic> overallData = jsonDecode(body);
    final Map<String, dynamic> json = overallData['json'];

    return json;
  }

  /// Creates a future to setup a timeout
  /// The future is resolved after a defined (magic number - sorry about that)
  /// period of seconds
  Future<void> _timeout() {
    const duration = Duration(seconds: 5);

    // we require a completer to manually resolve a future
    final completer = Completer();

    // setup a onetime timer
    Timer(duration, () => completer.complete());

    return completer.future;
  }

  /// Receive the device name
  /// This method also takes into consideration the different platforms
  Future<String?> _getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.utsname.nodename;
    }

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.model;
  }
}
