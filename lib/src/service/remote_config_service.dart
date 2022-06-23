import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// A class for getting the values set in the cloud with Firebase Remote Config
class RemoteConfigService {
  static const String maintenanceMode = "maintenance_mode";
  FirebaseRemoteConfig? _remoteConfig;

  //// Create a RemoteConfigService
  static Future<RemoteConfigService> build() async {
    var remoteConfigService = RemoteConfigService();
    await remoteConfigService._init();
    return remoteConfigService;
  }

  /// Initialize
  _init() async {
    _remoteConfig = await _setupRemoteConfig();
  }

  /// Setup Remote Config
  Future<FirebaseRemoteConfig> _setupRemoteConfig() async {
    await Firebase.initializeApp();
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await remoteConfig.setDefaults(<String, dynamic>{
      maintenanceMode: false,
    });
    RemoteConfigValue(null, ValueSource.valueStatic);
    return remoteConfig;
  }

  /// Whether it is in maintenance mode
  Future<bool> isMaintenanceMode() async {
    var remoteConfig = _remoteConfig;
    if (remoteConfig == null) {
      return false;
    }
    try {
      await remoteConfig.fetchAndActivate();
      var isMaintenance = remoteConfig.getBool(maintenanceMode);
      return isMaintenance;
    } catch (exception) {
      // ignored, really.
    }
    return false;
  }
}
