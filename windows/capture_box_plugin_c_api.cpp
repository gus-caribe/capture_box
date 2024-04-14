#include "include/capture_box/capture_box_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "capture_box_plugin.h"

void CaptureBoxPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  capture_box::CaptureBoxPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
