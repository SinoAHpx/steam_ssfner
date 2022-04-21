import 'package:win32_registry/win32_registry.dart';

class Win32Service {
  static String? getSteamPathByRegistry() {
    final key = Registry.openPath(RegistryHive.currentUser,
        path: r'Software\Valve\Steam');

    final path = key.getValueAsString("SteamPath");

    return path;
  }
}
