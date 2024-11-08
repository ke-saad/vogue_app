import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAwUYnru6hvIW5VCUaaJ3IeGgCEWku4WZg',
    appId: '1:876525886643:web:ad74728d2c9ae71e91a4c6',
    messagingSenderId: '876525886643',
    projectId: 'vogue-app-fa5f6',
    authDomain: 'vogue-app-fa5f6.firebaseapp.com',
    storageBucket: 'vogue-app-fa5f6.appspot.com',
    measurementId: 'G-125VELKXK3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCp7OWes74L-x1RM3OLBXgHWzC5UmpTKV8',
    appId: '1:876525886643:android:e514e7447a32c25d91a4c6',
    messagingSenderId: '876525886643',
    projectId: 'vogue-app-fa5f6',
    storageBucket: 'vogue-app-fa5f6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsVNZ2KTnxdqvK8K0f-h2baudUMgbadyI',
    appId: '1:876525886643:ios:c201428d1ed1ba1991a4c6',
    messagingSenderId: '876525886643',
    projectId: 'vogue-app-fa5f6',
    storageBucket: 'vogue-app-fa5f6.appspot.com',
    iosBundleId: 'com.example.vogueApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsVNZ2KTnxdqvK8K0f-h2baudUMgbadyI',
    appId: '1:876525886643:ios:c201428d1ed1ba1991a4c6',
    messagingSenderId: '876525886643',
    projectId: 'vogue-app-fa5f6',
    storageBucket: 'vogue-app-fa5f6.appspot.com',
    iosBundleId: 'com.example.vogueApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAwUYnru6hvIW5VCUaaJ3IeGgCEWku4WZg',
    appId: '1:876525886643:web:e12916ffd14fbe7291a4c6',
    messagingSenderId: '876525886643',
    projectId: 'vogue-app-fa5f6',
    authDomain: 'vogue-app-fa5f6.firebaseapp.com',
    storageBucket: 'vogue-app-fa5f6.appspot.com',
    measurementId: 'G-R1MKXN2GFR',
  );
}
