# はじめに

FirebaseのAuthenticationサンプルです

## 概要

FirebaseのAuthenticationを使用してemailアドレスでサインイン・サインアウトを実行するサンプル。
状態管理にreduxを採用したバージョン。

## 流れ

1.画面を作る
　今回はスプラッシュ・サインイン・サインアップ・ホームの３画面構成

2.FirebaseのSDK導入

pubspec.yaml
```
  firebase_core: ^0.4.0
  firebase_auth: ^0.12.0
  firebase_messaging: ^5.1.8
  cloud_firestore: ^0.13.3
```

3.iOSの対応（iOSシュミレータで動かす人）

ios/Podfile
```
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Messaging'
```
※Xcodeのビルドツールのバージョンが古いとコンパイルエラーになります！！
案件の都合で変えられない場合は諦めてAndroidのエミュレータで実行しましょう


ios/Runner/AppDelegate.swift
```
import UIKit
import Flutter
import Firebase ←　これ追記

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    ↓これ追記
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
    ↑これ追記
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

4.Androidの対応（Androidシュミレータで動かす人）

android/build.gradle
```
buildscript {
    ext.kotlin_version = '1.3.50'
    repositories {
        google()    ←　これがあることを確認する
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:3.5.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.3'
    }

}

allprojects {
    repositories {
        google()　←　これがあることを確認する
        jcenter()
    }
}

```

android/app/build.gradle
```
↓これ追記
apply plugin: 'com.google.gms.google-services'
↑これ追記

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"

    implementation 'com.google.firebase:firebase-analytics:17.4.4' ←　これ追記
}
```

5.Firebaseのプロジェクト作成してiOS/Androidの追加
公式サイトの通りにやると全然難しくない。むしろ簡単。
※iOSのBundleIdentiferは「PRODUCT_BUNDLE_IDENTIFIER」でgrepすると出てくる

6.GoogleService-Info.plist/google-services.jsonをダウンロードしてプロジェクトに配置

ios/Runner/GoogleService-Info.plist

android/app/google-services.json
