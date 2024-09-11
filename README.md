# Event Management Application

The Event Management application provides a robust platform for creating, updating, deleting, and editing events, as well as filtering them based on various criteria. The backend is built using Node.js with Firebase Functions to handle server-side logic and Firebase Firestore for real-time data storage.

<h1>Application Preview</h1>

https://github.com/user-attachments/assets/680ddaa1-eb90-436a-bc66-4811d48b9ad7

<h1>Used Technologies and Services</h1>

  - Backend Application: The server-side is a Node.js application structured using the MVC (Model-View-Controller) design pattern, although primarily focusing on the Model and Controller layers since Firebase handles the View component indirectly.
  - Frontend Application: The frontend is built using Flutter, which interacts with backend services via Firebase and direct HTTP requests to the Firebase Functions.

<h1>Firebase Services</h1>

  - Firebase Firestore: Used for storing event data that supports real-time synchronization.
  - Firebase Functions: Provides a serverless environment to execute backend code in response to HTTP requests or Firestore document changes.
  - Firebase Storage: Manages file storage, allowing event-related images and documents to be stored and retrieved efficiently.

# Installation

## Frontend Application Setup (Flutter)
To quickly set up the Flutter project, follow these steps:
1. Open the frontend folder in Visual Studio Code or Android Studio.
2. Open a terminal in the frontend folder and run the following commands:
   - `flutter pub get` to install the required packages.
   - Ensure the `firebase_options.dart` file is added to the `frontend/lib/` directory.
   - `flutter run` to start the application.

## Backend Application Setup (Node.js)
To set up the Node.js backend, follow these instructions:
1. Open the backend application in Visual Studio Code or your preferred IDE.
2. Navigate to the `backend/functions` folder in the terminal.
3. Run `npm install` to install dependencies.
4. Add the `event-management-ea467-firebase-adminsdk-4rewt-8e89add026.json` file to the `backend/functions/` directory for Firebase admin access.
5. To deploy the code to the Firebase server:
   - Navigate back to the backend directory using `cd ..`
   - Run `firebase deploy --only functions` to deploy the functions.




