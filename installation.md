
# FoodBridge - Installation Guide

This guide will help you set up the FoodBridge app locally for **development** and **testing**. FoodBridge is a Flutter app using Firebase as backend.

---

## Prerequisites

Make sure you have installed:

- [Flutter](https://docs.flutter.dev/get-started/install) (>=3.0)
- [Dart](https://dart.dev/get-dart)
- [Git](https://git-scm.com/)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- Android Studio or VS Code
- Node.js & npm (optional, for Firebase emulators)

---

## Clone the Repository

```bash
git clone https://github.com/<your-username>/foodbridge_app.git
cd foodbridge_app
````

---

## Install Dependencies

```bash
flutter pub get
```

---

## Configure Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/).

2. Create a new project called `FoodBridge`.

3. Add Android, iOS, and Web apps.

   * Android: place `google-services.json` in `/android/app/`
   * iOS: place `GoogleService-Info.plist` in `/ios/Runner/`
   * Web: replace Firebase config in `/web/index.html`

4. Enable services:

   * Firestore Database
   * Firebase Authentication (Email/Password)
   * Firebase Storage (for food images)

5. Optional: Use these Firestore rules:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /foods/{foodId} {
      allow read, write: if true;
    }
    match /metrics/{docId} {
      allow read, write: if true;
    }
  }
}
```

---

## Run the App

### Android / iOS

```bash
flutter run
```

### Web

```bash
flutter run -d chrome
```

---

## Testing

* Tests are under `/test`.
* Run tests with:

```bash
flutter test
```

---

## Environment Variables (Optional)

Create `.env` file at project root:

```env
GOOGLE_MAPS_API_KEY=YOUR_API_KEY_HERE
FIREBASE_API_KEY=YOUR_API_KEY_HERE
```

Use `flutter_dotenv` to load them.

---

## Troubleshooting

* **Missing packages:**

```bash
flutter clean
flutter pub get
```

* **Firebase auth fails:** Add your Android SHA-1 key in Firebase.
* **Map not showing:** Add API key to `index.html` (Web) and `AndroidManifest.xml` (Android).

````

---

### **2️⃣ API_DOC.md**

```markdown
# FoodBridge - API Documentation

FoodBridge uses **Firebase Firestore** as the backend. Below are collections, fields, and CRUD operations.

---

## Authentication

**Sign Up / Login** via Firebase SDK:

```dart
// Sign Up
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);

// Login
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);
````

**User Roles**

* Stored in `users` collection
* Fields:

  * `uid`: string
  * `role`: string (`donor` / `volunteer`)
  * `name`: string
  * `email`: string

---

## Firestore Collections

### 1. Foods Collection

**Path:** `/foods/{foodId}`

**Fields:**

| Field Name   | Type      | Description                       |
| ------------ | --------- | --------------------------------- |
| `name`       | string    | Name of food item                 |
| `quantity`   | number    | Quantity available                |
| `expiryDate` | timestamp | Expiry date of food               |
| `imageUrl`   | string    | Image URL                         |
| `location`   | GeoPoint  | Latitude & Longitude              |
| `donorId`    | string    | UID of donor                      |
| `status`     | string    | `available`, `claimed`, `expired` |

**Example JSON:**

```json
{
  "name": "Bread Loaf",
  "quantity": 5,
  "expiryDate": "2026-03-05T12:00:00Z",
  "imageUrl": "https://example.com/bread.jpg",
  "location": {"_latitude": 3.1390, "_longitude": 101.6869},
  "donorId": "uid12345",
  "status": "available"
}
```

---

### 2. Metrics Collection

**Path:** `/metrics/{docId}`

**Fields:**

| Field Name       | Type      | Description         |
| ---------------- | --------- | ------------------- |
| `totalDonations` | number    | Total donated items |
| `totalClaims`    | number    | Total claimed items |
| `timestamp`      | timestamp | Last update         |

---

## CRUD Operations (Flutter SDK)

**Create Food Item:**

```dart
FirebaseFirestore.instance.collection('foods').add({
  'name': 'Apples',
  'quantity': 10,
  'expiryDate': Timestamp.fromDate(DateTime(2026, 2, 28)),
  'location': GeoPoint(3.1390, 101.6869),
  'donorId': currentUser.uid,
  'status': 'available',
});
```

**Read Food Items:**

```dart
FirebaseFirestore.instance.collection('foods')
    .where('status', isEqualTo: 'available')
    .get();
```

**Update Food Status:**

```dart
FirebaseFirestore.instance.collection('foods')
    .doc(foodId)
    .update({'status': 'claimed'});
```

**Delete Food Item:**

```dart
FirebaseFirestore.instance.collection('foods')
    .doc(foodId)
    .delete();
```

---

## Notes

* All operations are secured with Firestore rules.
* Use snapshots for real-time updates in Flutter.

```
