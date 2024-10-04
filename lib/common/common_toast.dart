import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///////////////////////////////////////////////////////////////
//////////////////////[ COMMON_TOAST]/////////////////////////
///////////////////////////////////////////////////////////////
///
/// --- [ uses ]
/// to show informative, warning, error toast
///
/// --- [ used_dependencies ]
/// --> fluttertoast:
///
///////////////////////////////////////////////////////////////

final rootNavigatorKey = GlobalKey<NavigatorState>();

Future<bool?> showToast(String msg, {String? bgColor, String? color}) {
  return Fluttertoast.showToast(
      // backgroundColor: Colors.white,
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 17,
      // textColor: Colors.black,
      gravity: ToastGravity.BOTTOM);
}

// extension SnackBars on BuildContext {
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(String msg, {Color? textColor, Color? color}) {
  final SnackBar snackBar = SnackBar(
    backgroundColor: color ?? Colors.grey.shade800,
    content: Text(msg, style: TextStyle(color: Colors.white)),
  );

  ScaffoldMessenger.of(rootNavigatorKey.currentContext!).hideCurrentSnackBar();
  return ScaffoldMessenger.of(rootNavigatorKey.currentContext!).showSnackBar(snackBar);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbarSuccess(String msg, {Color? textColor, Color? color}) => showSnackbar(
      msg,
      color: color ?? Colors.green,
      textColor: textColor ?? Colors.white,
    );
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbarError(String msg, {Color? textColor, Color? color}) => showSnackbar(
      msg,
      color: color ?? Colors.grey.shade800,
      textColor: textColor ?? Colors.white,
    );
// }
