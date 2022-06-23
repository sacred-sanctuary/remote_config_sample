import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Maintenance dialog
class MaintenanceModeDialog {
  final BuildContext _context;
  static Future? _dialog;

  MaintenanceModeDialog(this._context);

  /// Display the maintenance dialog. If all are displayed, do nothing.
  static showMaintenanceModeDialog(BuildContext context) {
    if (_dialog != null) return;
    var forceUpdateDialog = MaintenanceModeDialog(context);
    forceUpdateDialog._showMaintenanceModeDialog();
  }

  void _showMaintenanceModeDialog() {
    _dialog = showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          child: _createForceUpdateDialog(),
          onWillPop: () async => false,
        );
      },
    ).then((_) => _dialog = null);
  }

  Widget _createForceUpdateDialog() {
    const title = "メンテナンス";
    const message = "メンテナンス中です。復旧まで今しばらくお待ちください。";
    const btnLabel = "OK";

    return AlertDialog(
      title: const Text(title),
      content: const Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text(
            btnLabel,
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => _finish(),
        ),
      ],
    );
  }

  /// Exit the app
  void _finish() {
    SystemNavigator.pop();
  }
}
