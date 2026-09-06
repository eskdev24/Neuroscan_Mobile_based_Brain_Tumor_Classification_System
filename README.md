# Neuroscan AI — Brain Tumor Classification System

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![TensorFlow Lite](https://img.shields.io/badge/TFLite-On--Device%20ML-FF6F00?logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20RTDB-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![SQLite](https://img.shields.io/badge/Storage-SQLite%20%28sqflite%29-003B57?logo=sqlite&logoColor=white)](https://pub.dev/packages/sqflite)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Neuroscan AI** is an artificial intelligence-driven mobile diagnostic assistant developed as a final-year engineering capstone project. The application performs instant, high-accuracy, on-device classification of Magnetic Resonance Imaging (MRI) brain scans into four distinct categories: **Glioma**, **Meningioma**, **Pituitary Tumor**, and **No Tumor (Healthy)**.

---

## 📌 Table of Contents

- [Executive Summary](#-executive-summary)
- [Key Features](#-key-features)
- [Machine Learning & Diagnostic Pipeline](#-machine-learning--diagnostic-pipeline)
- [System Architecture](#-system-architecture)
- [Technology Stack](#-technology-stack)
- [Project Directory Structure](#-project-directory-structure)
- [Database & Cloud Schemas](#-database--cloud-schemas)
- [Getting Started & Installation](#-getting-started--installation)
- [Configuration Guide](#-configuration-guide)
- [Running Tests & Quality Checks](#-running-tests--quality-checks)
- [Clinical Disclaimer & Ethics](#-clinical-disclaimer--ethics)

---

## 🔬 Executive Summary

Brain tumor diagnosis typically requires specialized radiological expertise and time-consuming manual assessment. **Neuroscan AI** bridges this gap by providing healthcare practitioners and researchers with a portable, offline-capable, and privacy-preserving clinical decision-support tool. 

By leveraging a quantized **TensorFlow Lite (TFLite)** neural network directly on edge devices, inference is performed in **sub-100 milliseconds** with zero cloud latency and strict patient data confidentiality.

---

## ✨ Key Features

- **⚡ On-Device Neural Inference:** Edge processing using `brain_tumor_model.tflite` via `tflite_flutter`—no internet connection required for scan evaluation.
- **🎯 4-Class Differential Classification:**
  - **Glioma** (Glial cell tumor)
  - **Meningioma** (Meningeal membrane tumor)
  - **Pituitary Tumor** (Endocrine gland adenoma)
  - **No Tumor** (Normal / Healthy brain scan)
- **📊 Real-Time Diagnostic Dashboard:** Visual multi-class probability meters, primary prediction confidence, and execution duration in milliseconds.
- **📄 Professional PDF Clinical Reports:** Automatic vector PDF generation formatted with medical headers, patient metadata, MRI scan preview, per-class breakdown, and clinical disclaimer for instant sharing and printing.
- **🔄 Dual Persistence & Cloud Sync:**
  - **Local Storage:** SQLite (`sqflite`) database for offline record keeping.
  - **Cloud Synchronization:** Secure backup to Firebase Realtime Database with user isolation.
- **🔐 Healthcare Practitioner Authentication:** Firebase Authentication with email verification, secure password reset, and practitioner profiling (Role, Hospital/Affiliation, Phone, Region, Country).
- **🔔 Local Notifications:** Automated background notifications for scan completion, report readiness, and cloud synchronization alerts.
- **🎨 Modern Dark UI:** Human-factors-optimized medical UI designed for high contrast and low-light clinical reading environments.

---

## 🧠 Machine Learning & Diagnostic Pipeline

```
  [MRI Input] (Gallery / Camera)
         │
         ▼
  [Image Preprocessing]
  ├── Resize: 224 x 224 pixels
  ├── Color Space: RGB Normalized [0.0, 1.0] or [-1.0, 1.0]
  └── Tensor Formatting: Float32 Tensor [1, 224, 224, 3]
         │
         ▼
  [TFLite Interpreter Execution] (assets/brain_tumor_model.tflite)
         │
         ▼
  [Post-Processing & Confidence Extraction]
  ├── Output Tensor: [1, 4] probabilities (0.0–1.0, no softmax needed)
  └── Confidence Scores: Glioma %, Meningioma %, Pituitary %, No Tumor %
         │
         ▼
  [Clinical Decision Presentation & PDF Generation]
```

### Preprocessing Specifications
- **Input Tensor Dimensions:** `1 x 224 x 224 x 3` (Batch Size, Height, Width, Channels)
- **Data Type:** `Float32`
- **Output Labels:**
  - Index `0`: `Glioma`
  - Index `1`: `Meningioma`
  - Index `2`: `No Tumor`
  - Index `3`: `Pituitary Tumor`

---

## 🏗 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                     │
│  (Splash, Welcome, Auth, Home, Scan, Results, History, ...) │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   State Management Layer                    │
│             AppState (ChangeNotifier / Provider)            │
└──────────────┬──────────────────────────────┬───────────────┘
               │                              │
               ▼                              ▼
┌──────────────────────────────┐┌─────────────────────────────┐
│       Services Layer         ││       Data & ML Engine      │
│  ├── AuthService             ││  ├── TFLiteService          │
│  ├── DatabaseService (SQLite)││  │   (brain_tumor_model)    │
│  ├── NotificationService     ││  └── PdfService (Reporting) │
│  └── Firebase Realtime DB    ││                             │
└──────────────────────────────┘└─────────────────────────────┘
```

---

## 💻 Technology Stack

| Domain | Technology / Package | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | `3.44.6` | Cross-platform UI toolkit |
| **Language** | [Dart](https://dart.dev) | `3.12.2` | Strongly-typed object-oriented language |
| **State Management** | [Riverpod](https://pub.dev/packages/flutter_riverpod) | `2.6.1` | Reactive state management (code generation) |
| **Navigation** | [GoRouter](https://pub.dev/packages/go_router) | `14.8.1` | Declarative routing with deep link support |
| **Deep Learning** | [tflite_flutter](https://pub.dev/packages/tflite_flutter) | `0.12.1` | On-device TFLite model execution |
| **Authentication** | [firebase_auth](https://pub.dev/packages/firebase_auth) | `5.5.1` | Secure email/password auth & verification |
| **Cloud Database** | [firebase_database](https://pub.dev/packages/firebase_database) | `11.3.4` | Realtime database for multi-device sync |
| **Push Notifications** | [firebase_messaging](https://pub.dev/packages/firebase_messaging) | `15.2.1` | Firebase Cloud Messaging (FCM) |
| **Local Storage** | [sqflite](https://pub.dev/packages/sqflite) | `2.4.2` | Local relational SQLite database |
| **Report Engine** | [pdf](https://pub.dev/packages/pdf) | `3.11.2` | Medical-grade PDF rendering and layout |
| **System Sharing** | [share_plus](https://pub.dev/packages/share_plus) | `10.1.4` | Native OS share sheet integration |
| **Notifications** | [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) | `18.0.1` | Local scheduling and status alerts |
| **Permissions** | [permission_handler](https://pub.dev/packages/permission_handler) | `11.4.0` | Runtime permission management |
| **Code Generation** | [freezed](https://pub.dev/packages/freezed) + [build_runner](https://pub.dev/packages/build_runner) | `2.5.8` / `2.4.14` | Immutable data classes & JSON serialization |

---

## 📂 Project Directory Structure

```
neuroscan_ai/
├── android/                          # Android platform project
│   └── app/src/main/
│       ├── AndroidManifest.xml       # Permissions, FCM, notification config
│       └── res/                      # Icons, splash, notification drawables
├── assets/
│   ├── images/
│   │   ├── app_icon.png              # Custom adaptive app icon
│   │   ├── img_splash.png            # Splash/branding brain logo
│   │   └── welcome.png               # Welcome screen hero image
│   └── models/
│       ├── brain_tumor_model.tflite  # Pre-trained quantized neural network
│       └── labels.txt                # Output class mapping (4 labels)
├── lib/
│   ├── main.dart                     # Entry point, Riverpod, Firebase init
│   ├── app.dart                      # GoRouter config, ScaffoldWithBody, BottomNav
│   ├── core/
│   │   ├── firebase/
│   │   │   └── firebase_init.dart    # Firebase initialization
│   │   ├── notifications/
│   │   │   └── notification_service.dart # Local + FCM notifications
│   │   ├── pdf/
│   │   │   └── pdf_generator.dart    # Medical-grade PDF report generator
│   │   ├── routing/
│   │   │   ├── app_router.dart       # GoRouter route configuration
│   │   │   └── routes.dart           # Route name constants
│   │   └── theme/
│   │       ├── color.dart            # App color constants
│   │       ├── theme.dart            # Dark clinical theme
│   │       └── typography.dart       # Text styles & type scale
│   ├── features/
│   │   ├── about/presentation/
│   │   │   └── about_screen.dart     # Project info & model details
│   │   ├── auth/
│   │   │   ├── application/
│   │   │   │   ├── auth_controller.dart  # Auth state management (Riverpod)
│   │   │   │   └── auth_state.dart       # Auth state sealed class
│   │   │   ├── data/
│   │   │   │   └── auth_repository.dart  # Firebase Auth wrapper
│   │   │   └── presentation/
│   │   │       └── auth_screen.dart      # Login, register, password reset
│   │   ├── history/
│   │   │   ├── application/
│   │   │   │   └── history_controller.dart  # History state (Riverpod)
│   │   │   └── presentation/
│   │   │       ├── history_detail_dialog.dart # Detail view + PDF download
│   │   │       ├── history_item_card.dart     # Scan list item card
│   │   │       └── history_screen.dart        # Searchable scan history
│   │   ├── home/presentation/
│   │   │   └── home_screen.dart      # Dashboard with quick actions
│   │   ├── notifications/
│   │   │   ├── application/
│   │   │   │   └── notifications_controller.dart # Notification state
│   │   │   └── presentation/
│   │   │       └── notifications_screen.dart    # Notification list + clear
│   │   ├── profile/
│   │   │   ├── application/
│   │   │   │   └── profile_controller.dart  # Profile state (Riverpod)
│   │   │   └── presentation/
│   │   │       └── profile_screen.dart      # Practitioner profile
│   │   ├── scan/
│   │   │   ├── application/
│   │   │   │   └── scan_controller.dart     # Scan state (Riverpod)
│   │   │   ├── data/
│   │   │   │   ├── scan_local_dao.dart       # SQLite data access
│   │   │   │   ├── scan_repository.dart      # Scan CRUD operations
│   │   │   │   └── tflite_classifier.dart    # TFLite inference engine
│   │   │   └── presentation/
│   │   │       ├── loading_overlay.dart      # Scan progress overlay
│   │   │       ├── results_screen.dart       # Diagnostic results + bars
│   │   │       └── scan_screen.dart          # Camera/Gallery acquisition
│   │   ├── splash/presentation/
│   │   │   └── splash_screen.dart    # Animated startup & auth routing
│   │   └── welcome/presentation/
│   │       └── welcome_screen.dart   # Onboarding & introduction
│   └── shared/
│       ├── models/
│       │   ├── notification_item.dart  # Notification data model
│       │   ├── prediction_result.dart  # Diagnostic output model
│       │   ├── scan_item.dart          # Scan history entity (Freezed)
│       │   ├── scan_item.freezed.dart  # Freezed generated code
│       │   └── scan_item.g.dart        # JSON serialization generated
│       └── widgets/
│           ├── outlined_action_button.dart # Reusable outlined button
│           └── primary_button.dart         # Reusable primary button
├── test/                             # Unit & widget tests
└── pubspec.yaml                      # Dependencies & asset manifests
```

---

## 🗄 Database & Cloud Schemas

### 1. SQLite Relational Schema (`scan_history` table)

```sql
CREATE TABLE scan_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    resultType TEXT NOT NULL,
    confidence REAL NOT NULL,
    timestamp INTEGER NOT NULL,
    imagePath TEXT,
    gliomaScore REAL NOT NULL,
    meningiomaScore REAL NOT NULL,
    pituitaryScore REAL NOT NULL,
    noTumorScore REAL NOT NULL,
    inferenceTimeMs INTEGER NOT NULL
);
```

### 2. Firebase Realtime Database Structure

```json
{
  "users": {
    "<user_uid>": {
      "profile": {
        "email": "doctor@hospital.org",
        "role": "Radiologist",
        "hospital": "Central Neuro Hospital",
        "phone": "+1234567890",
        "stateRegion": "California",
        "country": "United States"
      },
      "scans": {
        "<scan_push_id>": {
          "resultType": "Glioma",
          "confidence": 96.4,
          "timestamp": 1730000000000,
          "gliomaScore": 96.4,
          "meningiomaScore": 2.1,
          "pituitaryScore": 0.9,
          "noTumorScore": 0.6,
          "inferenceTimeMs": 45,
          "imageBase64": "..."
        }
      }
    }
  }
}
```

---

## 🚀 Getting Started & Installation

### Prerequisites

| Requirement | Version |
| :--- | :--- |
| **Flutter SDK** | `3.44.6` or higher ([Install Flutter](https://flutter.dev/docs/get-started/install)) |
| **Dart SDK** | `3.12.2` or higher (bundled with Flutter) |
| **Android Studio** | Latest stable (for Android toolchain) |
| **JDK** | 17 (required by AGP 9.0) |
| **Firebase Project** | With Authentication (Email/Password) and Realtime Database enabled |

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/eskdev24/Neuroscan-Mobile-based-Brain-Tumor-Classification-System-.git
   cd neuroscan_ai
   ```

2. **Install Flutter packages:**
   ```bash
   flutter pub get
   ```

3. **Place the TFLite model:**
   Ensure the trained model is at `assets/models/brain_tumor_model.tflite` and labels at `assets/models/labels.txt`.

4. **Configure Firebase:**
   - Place your `google-services.json` in `android/app/`
   - Enable **Email/Password** authentication in Firebase Console
   - Create a **Realtime Database** instance (Firebase Console → Realtime Database)

5. **Verify Flutter environment:**
   ```bash
   flutter doctor
   ```

6. **Build and run:**
   ```bash
   # Run on connected device/emulator
   flutter run

   # Build release APK
   flutter build apk --release

   # Install on connected device
   flutter install
   ```

---

## ⚙ Configuration Guide

### Android Configuration

Ensure `android/app/build.gradle.kts` has the `aaptOptions` configuration to prevent asset compression for TensorFlow Lite model files:

```kotlin
android {
    ...
    aaptOptions {
        noCompress("tflite")
    }
}
```

And verify required permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

---

## 🧪 Building and Running

### Prerequisites
- Flutter SDK (>=3.2.0)
- Android Studio / Xcode (for platform toolchains)
- A connected device or emulator

### Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run linter + static analysis
flutter analyze

# Run unit/widget tests
flutter test

# Build Android APK
flutter build apk

# Build iOS app
flutter build ios
```
---

## Common Issues & Troubleshooting

| Issue | Solution |
|-------|----------|
| TFLite model not loading | Verify `assets/model/brain_tumor_model.tflite` exists and is declared in `pubspec.yaml` |
| Camera permission denied | Check `AndroidManifest.xml` and `Info.plist` for camera permission entries |
| iOS build fails | Run `flutter pub get` first; ensure iOS deployment target >= 12.0 |
| Model inference returns unexpected results | Confirm input preprocessing matches model training (224×224, RGB, [0,1] normalization) |

## ⚕ Clinical Disclaimer & Ethics

> [!IMPORTANT]
> **Research & Decision-Support Only:**
> Neuroscan AI is designed for academic, experimental, and clinical research purposes. It is intended to assist qualified medical professionals and radiologists as a complementary reference tool and **must not** be used as a standalone diagnostic system or substitute for professional medical judgment, or definitive clinical diagnosis.

---

## Authors & Acknowledgments

# Project Supervisor
- Prof. Peter Appiahene(Dean of Student) - University of Energy and   Natural Resources

- **Final Year Project Team** 

- Eugene Simpson (Project Lead/Developer)
- Emmanuella Afaribea (Assistant/Secretary)
- Ramadan Mohammed (Support 1)
- Vera Waye Agyemang (Support 2)
- Yussif Sualah Osman (Support 3)
# Department
Information Technology & Decision Sciences - UENR

- **Dataset Acknowledgments:** 
Brain Tumor MRI Dataset (Figshare / Kaggle)

- Built using Flutter and TensorFlow Lite.
