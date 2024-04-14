import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'capture_box_method_channel.dart';

abstract class CaptureBoxPlatform extends PlatformInterface {
  /// Constructs a CaptureBoxPlatform.
  CaptureBoxPlatform() : super(token: _token);

  static final Object _token = Object();

  static CaptureBoxPlatform _instance = MethodChannelCaptureBox();

  /// The default instance of [CaptureBoxPlatform] to use.
  ///
  /// Defaults to [MethodChannelCaptureBox].
  static CaptureBoxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CaptureBoxPlatform] when
  /// they register themselves.
  static set instance(CaptureBoxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
