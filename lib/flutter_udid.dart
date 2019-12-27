import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class FlutterUdid {
  static const MethodChannel _channel = const MethodChannel('flutter_udid');

  static Future<String> get udid async {
    final String udid = await _channel.invokeMethod('getUDID');
    return udid;
  }

  static Future<String> get consistentUdid async {
    final String udid = await _channel.invokeMethod('getUDID');
    var bytes = utf8.encode(udid);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<String> get newUdid async {
    final String udid = await _channel.invokeMethod('getNewUDID');
    return udid;
  }

  static Future<String> saveNewUdid(String uuid) async {
    final String udid = await _channel.invokeMethod('saveNewUDID', uuid);
    return udid;
  }
}
