# 🌍 FoodBridge

#### <div align="center"> 🔎 **FoodBridge addresses the urban food waste and food insecurity paradox.** </div>

---

## 👥 Team Introduction

### <div align="center">  Welcome to our project repository! <br> We are **Team Success 404**, a passionate team dedicated to building innovative and impactful solutions.
</div>

<br>

### 👤 Team Members

| Name                  | Universiti                    | GitHub                                         |
| --------------------- | ----------------------------- | ---------------------------------------------- |
| Gan Yu Xuan           | Universiti Teknologi Malaysia | [@ganyuxuan18](https://github.com/ganyuxuan18) |
| Jasmine Chin Ying Hui | Universiti Malaya             | [@jasmineyh](https://github.com/jasmineyh)     |
| Hee Hui En            | Universiti Teknologi Malaysia | [@heehuien](https://github.com/heehuien)       |
| Chia Jin Yi           | Universiti Malaya             | [@username](https://github.com/username)       |

---

# 📌 Project Overview

## ❓ Problem Statements

1. **Massive Food Waste**
   
   A large amount of edible food thrown away daily.

2. **Access Barriers**

   * Donors have food but no transport
   * NGOs have needs but no real-time data

3. **Information Gap**

   A manual phone-tag system cannot solve a real-time logistics problem.
  
4. **Food Spoils Before Redistribution**

    Surplus food has a lifespan of hours, not days.

<br>

## 🌍 Sustainable Development Goals

![SDG 2 - Zero Hunger](https://img.shields.io/badge/SDG_2-Zero_Hunger-DDA63A?style=for-the-badge)

### SDG 2 – Zero Hunger

Target 2.1: End hunger and ensure access to safe, nutritious food.

<br>

![SDG 11 - Sustainable Cities and Communities](https://img.shields.io/badge/SDG_11-Sustainable_Cities-D27C2C?style=for-the-badge)

### SDG 11 – Sustainable Cities and Communities

Target 11.6: Reduce environmental impact of cities, including waste management.

<br>

![SDG 12 - Responsible Consumption and Production](https://img.shields.io/badge/SDG_12-Responsible_Consumption-BF8B2E?style=for-the-badge)

### SDG 12 – Responsible Consumption and Production

Target 12.3: Halve per capita global food waste at retail and consumer levels.

<br>

## 💡 Description Solution

1. **Donor Upload**

   Uploads the food to the platform.

2. **AI Classification**

   AI evaluates food freshness and potential risk.

3. **Urgency Scoring**

   System categorizes and prioritizes items flagged as urgent.

4. **NGO Matching**

   AI ensures a high-precision match based on location, cause, and operational transparency.

5. **Route Generation**

   System generates clear navigation routes for volunteers.

6. **Delivery**

   System stores waste metrics and volumes for pattern analysis and optimization.

<br>

---

# ✨ Key Features

* Surplus Prediction Model
  
* Smart NGO Matching Algorithm

* Intelligent Route Generation

* Real-time Inventory Dashboard

* Impact Analytics Tracking

<br>

## 🚀 Value Proposition

* Faster response

* Reduce food waste

*  Transparent impact tracking

<br>

---

# 🤖 Google AI Technologies

![Cloud Functions](https://img.shields.io/badge/Cloud_Functions-4285F4?style=for-the-badge&logo=googlecloudfunctions&logoColor=white)

### Cloud Functions

Event-driven AI processing

* Acts as the event-driven backend that automatically triggers Gemini processing when new food data is uploaded.

<br>

![Google Maps API](https://img.shields.io/badge/Maps_API-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white)

### Google Maps API

Route generation

* Calculates distance and travel time estimation for efficient pickups.

<br>

![Gemini AI](https://img.shields.io/badge/Gemini-4285F4?style=for-the-badge&logo=google&logoColor=white)

### Gemini API

AI classification & matching

* Classifies food items, predicts spoilage risk, and generates priority scores to support intelligent redistribution and volunteer matching.

<br>

---

# 🛠 Google Developer Technologies

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)

### Flutter

Cross-platform development (Android & iOS)

* Single codebase with consistent user experience.

<br>

![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

### Firebase Firestore

Real-time database

* Stores food uploads, NGO requests, and volunteer activities.
* Provides real-time updates and seamless Google integration.

<br>

![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=googlebigquery&logoColor=white)

### BigQuery

Scalable data analytics

* Identifies surplus food patterns, delivery efficiency, and spoilage trends.

<br>

---

# 🧠 Implementation Details & Innovation

## 🧰 System Architecture

### Frontend

* Flutter App (Cross-platform UI)

### Backend

* Firebase Firestore (Real-time database)
* Cloud Functions (Trigger AI processing)

### Analysis

* BigQuery (Surplus pattern analysis)

### Routing

* Google Maps API (Route generation)

### AI Layer

* Gemini API (Spoilage classification)

<br>

## 🔄 Workflow

1. **Donor Upload**

   Describe image, food type, and quantity.

2. **AI Processing**

   Gemini analyzes food category and estimates risk level.

3. **Smart Matching Engine**

   AI calculates urgency score and matches nearby volunteers.

4. **Route Generation**

   Google Maps API calculates distance, time estimation, and pickup sequence.

5. **Delivery**

   Digital handshake verifies condition and quantity.

6. **Analytics**

   BigQuery stores data for weekly pattern insights.

<br>

---

# 🧩 Challenges Faced

| Challenge             | Description                        | Solution                              |
| --------------------- | ---------------------------------- | ------------------------------------- |
| Data Quality          | Incomplete donor inputs            | Visual status and countdown timer     |
| Food Safety           | Spoilage uncertainty               | AI extraction and risk scoring        |
| Real-time Sync Issues | Volunteers arriving at empty shops | Real-time matching with Gemini        |
| Cold Chain            | Temperature-sensitive transport    | “Needs Cooler” flags and guidelines   |
| Data Scarcity         | Limited spoiled food datasets      | Synthetic data and prompt tuning      |
| False Positives       | Safe food flagged as risky         | Human verification for low confidence |

<br>

---

# ⚙️ Installation & Setup

## Installation

### Prerequisites

Before setting up the project, ensure the following are installed:

#### 1. Flutter SDK

   * Version >= 3.0
   * Installation guide: [Flutter Official Docs](https://flutter.dev/docs/get-started/install)

#### 2. Android Studio or VS Code

   * Required for Android builds and emulator testing.

#### 3. Firebase Account

   * Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   * Enable Authentication (Email/Password) and Cloud Firestore

#### 4. Git

   * For cloning the project repository
   * Download: [Git](https://git-scm.com/downloads)

<br>

## Setup

### Step 1 - Clone the repository

      git clone https://github.com/<your-username>/<your-repo>.git
      cd <your-repo>

<br>

### Step 2 - Install Flutter dependencies

      flutter pub get

<br>

### Step 3 - Connect Firebase

#### 1️⃣ Create Firebase Project

1. Go to Firebase Console

2. Click Create Project

3. Enable:

   * Authentication → Email/Password
   * Cloud Firestore

#### 2️⃣ Add Android App

1. Register Android app in Firebase

2. Download google-services.json

3. Place it inside:

         android/app/google-services.json

#### 3️⃣ Add iOS App (Optional)

1. Register iOS app

2. Download GoogleService-Info.plist

3. Place it inside:

         ios/Runner/GoogleService-Info.plist

#### 4️⃣ Configure FlutterFire (Recommended)

      dart pub global activate flutterfire_cli
      flutterfire configure

<br>

### Step 4 - Enable Maps & Routing

#### 1️⃣ Go to Google Cloud Console

#### 2️⃣ Enable:

   - Maps SDK for Android
   - Maps SDK for iOS
   - Directions API (if used)

#### 3️⃣ Add your API key inside:

      android/app/src/main/AndroidManifest.xml

<br>

### Step 5 - Run the Application

#### ▶ Run on Chrome (Web)

      flutter run -d chrome

#### ▶ Run on Android Device / Emulator
      
      flutter run

<br>

### Step 6 - Build Release Version

#### ▶ Android APK
      
      flutter build apk --release

#### ▶ Web Build

      flutter build web

<br>

### ✅ Setup Complete

<br>

## 🎥 Demonstration Video

(Add demo video link here)

<br>

---

# 🔮 Future Roadmap

Manual Listing and Standard Routing → Predictive Forecasting → Hunger Heatmaps

### Year 1 – City Pilot 🏗️

* 20–30% waste reduction
* Baseline impact metrics
* UX improvement

### Year 2 – Ecosystem Scale Integration 🛡️

* Municipal waste system integration
* Public API for logistics partners
* Corporate ESG reporting

### Year 3 – Marketplace Expansion 📊

* Multi-city rollout (Penang, JB, Singapore)
* National smart infrastructure
* B2B marketplace for packaging and logistics

<br>

****

![Page Views](https://komarev.com/ghpvc/?username=ganyuxuan18&repo=Documentation-FoodBridge&label=Page%20Views&style=for-the-badge)
