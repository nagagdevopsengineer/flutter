import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/ColorPallete.dart';
import 'package:gpapp/Controllers/CommonController.dart';
import 'package:gpapp/Screens/Decider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:update_handler/update_handler.dart';

var isLogin = false;
late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://f6dc7dfd521642898c640dcf9f5ad105@o1418588.ingest.sentry.io/6761868';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}

void checkVersion(context) {
  UpdateHandler().isUpdateAvailable(
    latestBuildNo: 11,
    lastForceBuildNo: 11,
    context: context,
    title: "UPDATE NOW",
    content: "NEW APP UPDATE AVAILABLE PLEASE UPDATE ASAP",
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ds.write("userId", "327a57f5-db85-4d46-ac6d-3645813160c5");
    var c = Get.put(CommonController());
    c.availableCamera = _cameras;
    return GetMaterialApp(
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: ColorPallete.primary, primary: ColorPallete.primary),
      ),
      title: "Gourmet Planet",
      home: Decider(),
      builder: (context, child) {
        final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        );
      },
    );
  }
}
