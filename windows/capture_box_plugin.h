#ifndef FLUTTER_PLUGIN_CAPTURE_BOX_PLUGIN_H_
#define FLUTTER_PLUGIN_CAPTURE_BOX_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace capture_box {

class CaptureBoxPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  CaptureBoxPlugin();

  virtual ~CaptureBoxPlugin();

  // Disallow copy and assign.
  CaptureBoxPlugin(const CaptureBoxPlugin&) = delete;
  CaptureBoxPlugin& operator=(const CaptureBoxPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace capture_box

#endif  // FLUTTER_PLUGIN_CAPTURE_BOX_PLUGIN_H_
