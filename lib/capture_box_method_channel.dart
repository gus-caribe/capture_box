import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'capture_box_platform_interface.dart';

/// An implementation of [CaptureBoxPlatform] that uses method channels.
class MethodChannelCaptureBox extends CaptureBoxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('capture_box');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
