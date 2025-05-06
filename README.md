EyeLoveU ─ Eye Care Companion (macOS)
This is a lightweight eye care reminder application developed using Swift + SwiftUI for macOS.

Key Features
Status bar icon with pop-up menu

Keyboard/mouse activity detection to calculate actual working time

Automatic timer pause and reset when idle for a specified duration

Full-screen rest reminder window (with sound effect)

Multi-language support (auto-detected from system settings)

Preferences window

Technical Implementation
Swift 5 + SwiftUI + AppKit

UserDefaults for preference storage

Multi-language localization support

Compatible with macOS 13+ on both arm64 and Intel x86_64 platforms

How to Run
Open the project in Xcode

Select EyeLoveUApp as the launch target

Build & Run (⌘R)

Project Structure
EyeLoveUApp.swift: App entry point

StatusBarController.swift: Manages status bar icon and menu

IdleMonitor.swift: Keyboard/mouse activity detection

RestReminderWindow.swift: Full-screen rest reminder

SettingsView.swift: Preferences view

Localization/: Multi-language resources

Assets.xcassets: App icons

Installation & Usage
Package the app into a DMG installer using CreateDMG

Run the installer and drag EyeLoveU.app to the Applications folder

Open macOS "System Settings" → "Privacy & Security" → "Accessibility", click "+" and select EyeLoveU from the Applications folder. This permission is required for keyboard/mouse activity detection to track working time.

For auto-launch at startup: Open "System Settings" → "General" → "Login Items", click "+" and select EyeLoveU.

Since this is not an Apple Developer certified application, first-time users need to right-click EyeLoveU.app in the Applications folder, select "Open", then authenticate with your password. This step is only required once.



*******************



# EyeLoveU ─ 護眼精靈 (macOS)

這是一款精簡版護眼提醒軟體，使用 Swift + SwiftUI 開發，支援 macOS。

## 主要功能
- 狀態列圖示與 Pop-up 選單
- 鍵盤滑鼠偵測，計算實際工作時間
- IDLE 超過一定的秒數，會自動暫停計時，並重設工作計時
- 全螢幕休息提醒視窗（含音效）
- 支援多語系（系統自動偵測）
- 偏好設定視窗

## 開發技術
- Swift 5 + SwiftUI + AppKit
- UserDefaults 儲存偏好
- 多語系支援
- 支援Mac OS 13以後版本，arm64與intel x86 64平台

## 如何執行
1. 使用 Xcode 開啟本專案
2. 選擇 EyeLoveUApp 作為啟動目標
3. Build & Run (⌘R)

## 專案結構
- EyeLoveUApp.swift：App 進入點
- StatusBarController.swift：管理狀態列圖示與選單
- IdleMonitor.swift：鍵盤滑鼠活動偵測
- RestReminderWindow.swift：全螢幕休息提醒
- SettingsView.swift：偏好設定
- Localization/：多語系資源
- Assets.xcassets：圖示

## 安裝與使用
- 使用CreateDMG將app檔案包裝成dmg安裝程式
- 執行安裝程式，將EyeLoveU app拉到Application資料夾
- 開啟Mac「系統設定」/「隱私權與安全性」/「輔助使用」，按下＋按鈕，指定Application資料夾中的EyeLoveU。由於需要檢測鍵盤與滑鼠動作，來判定工作時常，請務必執行此動作，不然功能將無作用
- 如果希望開機自動執行，開啟Mac「系統設定」/「一般」/「登入項目與延伸功能」，按下＋按鈕，指定Application資料夾中的EyeLoveU，下次開機即可自動啟動。
- 由於不是Apple Developer認證程式，因此第一次執行時，需要在Application資料夾中，以右鍵點選EyeLoveU，從選單中選擇「打開」，輸入用戶密碼後，以後即可正常開啟，無須重複此步驟。
