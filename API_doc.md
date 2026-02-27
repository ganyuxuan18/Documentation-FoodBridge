# FoodBridge - API Documentation

FoodBridge uses **Firebase Firestore** as the backend for storing foods, tracking metrics, and managing users. This document describes the Firestore structure, fields, and CRUD operations.

---

## **1. Authentication**

Authentication is handled via **Firebase Authentication** (Email/Password).

### Sign Up
```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);
````

### Login

```dart
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);
```

### User Roles

* Stored in the `users` collection.
* Fields:

| Field Name | Type   | Description                      |
| ---------- | ------ | -------------------------------- |
| uid        | string | Firebase user UID                |
| role       | string | User role: `donor` / `volunteer` |
| name       | string | Full name of the user            |
| email      | string | User email address               |

---

## **2. Firestore Collections**

### **A. Foods Collection**

**Path:** `/foods/{foodId}`

**Fields:**

| Field Name | Type      | Description                       |
| ---------- | --------- | --------------------------------- |
| name       | string    | Name of food item                 |
| quantity   | number    | Quantity available                |
| expiryDate | timestamp | Expiry date of food               |
| imageUrl   | string    | Image URL of the food item        |
| location   | GeoPoint  | Latitude & Longitude              |
| donorId    | string    | UID of the donor                  |
| status     | string    | `available`, `claimed`, `expired` |

**Example Document:**

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

### **B. Metrics Collection**

**Path:** `/metrics/{docId}`

**Purpose:** Track donations, claims, and app statistics.

| Field Name     | Type      | Description         |
| -------------- | --------- | ------------------- |
| totalDonations | number    | Total donated items |
| totalClaims    | number    | Total claimed items |
| timestamp      | timestamp | Last update         |

---

## **3. CRUD Operations (Flutter SDK)**

### **Create Food Item**

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

### **Read Food Items**

```dart
FirebaseFirestore.instance.collection('foods')
    .where('status', isEqualTo: 'available')
    .get();
```

### **Update Food Status**

```dart
FirebaseFirestore.instance.collection('foods')
    .doc(foodId)
    .update({'status': 'claimed'});
```

### **Delete Food Item**

```dart
FirebaseFirestore.instance.collection('foods')
    .doc(foodId)
    .delete();
```

---

## **4. Notes & Best Practices**

* All operations are secured with Firestore security rules. Adjust rules as needed for production.
* Use `snapshots()` in Flutter for real-time updates.
* Always validate data before writing to Firestore.
* Handle errors with try/catch for smooth user experience.

---

## **5. Example Firestore Rules**

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
