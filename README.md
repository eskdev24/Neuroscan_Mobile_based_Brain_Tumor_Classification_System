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
  [Post-Processing & Softmax Normalization]
  ├── Output Tensor: [1, 4] logits / probabilities
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

| Domain | Technology / Package | Purpose |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (SDK >= 3.4.0) | Cross-platform UI toolkit |
| **Language** | [Dart](https://dart.dev) (3.4+) | Strongly-typed object-oriented language |
| **Deep Learning** | `tflite_flutter` (0.11.0) | On-device TFLite model execution |
| **Computer Vision** | `image` (4.5.3) | MRI scan resizing and pixel tensor extraction |
| **Authentication** | `firebase_auth` (5.3.3) | Secure email/password auth & verification |
| **Cloud Database** | `firebase_database` (11.3.0) | Realtime database for multi-device sync |
| **Local Storage** | `sqflite` (2.4.1) & `path` | Local relational SQLite database |
| **State Management**| `provider` (6.1.2) | Reactive state management architecture |
| **Report Engine** | `pdf` (3.11.1) & `printing` | Medical-grade PDF rendering and layout |
| **System Sharing** | `share_plus` (10.1.4) | Native OS share sheet integration |
| **Notifications** | `flutter_local_notifications` (18.0.1) | Local scheduling and status alerts |

---

## 📂 Project Directory Structure

```
neuroscan_ai/
├── assets/
│   ├── brain_tumor_model.tflite    # Pre-trained quantized neural network
│   ├── labels.txt                  # Output class mapping
│   ├── img_mri_scan.png            # Demonstration MRI asset
│   └── img_splash.png              # App branding asset
├── lib/
│   ├── firebase_options.dart       # Firebase platform configuration
│   ├── main.dart                   # Application entry point & navigation shell
│   ├── models/
│   │   ├── prediction_result.dart  # Diagnostic output & notification models
│   │   └── scan_item.dart          # Scan history entity (SQLite/RTDB schema)
│   ├── providers/
│   │   └── app_state.dart          # Core application state & synchronization
│   ├── screens/
│   │   ├── about_screen.dart       # Project information, model details, ethics
│   │   ├── auth_screen.dart        # Login, registration, practitioner details
│   │   ├── history_screen.dart     # Searchable scan history & PDF export
│   │   ├── home_screen.dart        # Dashboard, statistics, quick actions
│   │   ├── notifications_screen.dart# System & sync notification logs
│   │   ├── profile_screen.dart     # Practitioner profile & credentials
│   │   ├── results_screen.dart     # Diagnostic results & confidence bars
│   │   ├── scan_screen.dart        # Camera/Gallery MRI acquisition
│   │   ├── splash_screen.dart      # Animated startup & auth routing
│   │   └── welcome_screen.dart     # Interactive introduction & onboarding
│   ├── services/
│   │   ├── auth_service.dart       # Firebase Authentication interface
│   │   ├── database_service.dart   # SQLite CRUD operations
│   │   ├── notification_service.dart# Local push notifications
│   │   ├── pdf_service.dart        # Vector PDF clinical report compiler
│   │   └── tflite_service.dart     # Tensor normalization & model inference
│   ├── theme/
│   │   └── app_theme.dart          # Dark clinical color palette & tokens
│   └── widgets/
│       └── confidence_bar.dart     # Custom animated diagnostic meter
├── test/
│   └── widget_test.dart            # Unit and widget test suite
└── pubspec.yaml                    # Project dependencies and asset manifests
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

- **Flutter SDK:** Version `3.4.0` or higher ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Dart SDK:** Version `3.4.0` or higher
- **Android Studio / Xcode** for mobile deployment
- **Java Development Kit (JDK):** Version 17 recommended

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/eskdev24/neuroscan_ai.git
   cd neuroscan_ai
   ```

2. **Install Flutter packages:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter environment:**
   ```bash
   flutter doctor
   ```

4. **Launch the application:**
   ```bash
   flutter run
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
