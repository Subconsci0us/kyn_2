Kyn - Know Your Neighbour
OVERVIEW
Kyn is a mobile application designed to strengthen connections within local communities by providing a platform for residents to share skills, services, and resources. Users can discover and connect with neighbors who offer valuable services—from home repairs to cooking and tutoring—directly within their area. The app also allows small businesses to market themselves locally, making it easy for residents to find neighborhood food delivery options, services, and special offers. Additionally, Know Your Neighbour facilitates communication around community events, emergency alerts, and social gatherings, encouraging active participation and support within the neighborhood. Through a combination of event sharing, skill-based assistance, and community-building features, Know Your Neighbour helps foster an engaged and resourceful community network.
Kyn is a feature-rich Flutter application that integrates Firebase services for authentication, real-time data updates, and Firestore database interaction. The app provides seamless navigation, user profile management, and event creation while ensuring a user-friendly UI with dynamic updates and aesthetic design.

Features
1. Authentication
Login: Secure authentication using email and password via Firebase Authentication.
Sign-Up: Register new users and initialize their profile in Firestore.
Real-Time Updates: Retrieve and listen to user data changes from Firestore in real-time.
2. Navigation with FAB
Bottom Navigation Bar: Switch between pages like Home, Events, Map, and Profile.
Floating Action Button (FAB): Quick access to post creation.
3. Home Page
Dashboard featuring:
Search Bar: Filter content by keywords.
Categories: Interactive category pills for tailored browsing.
Event Cards: Showcase upcoming events with details like date, location, and attendees.
4. Event Management
Create Events: Add new events with descriptions, categories, and date selection.
Event List: Display a scrollable list of events with search and filter options.
5. Profile Management
View and edit profile details.
Access activity logs and settings.
Sign-Out: Securely log out of the account.
6. Map Integration (Pending Completion)
Explore nearby places or events on an interactive map with search functionality.
7. Post Management
Add, update, and store posts in Firestore.
Categorize posts into predefined categories for better organization.

Getting Started
Prerequisites
Flutter SDK: Version 3.5.4 or above.
Firebase project configured with Firebase Authentication and Firestore.
Installation
Clone the repository: git clone https://github.com/your-username/kyn.git
Navigate to the project directory: cd kyn
Install dependencies: flutter pub get
Set up Firebase:
Replace the configuration in firebase_options.dart with Firebase project's details.
Ensure the assets and permissions required for Firebase are included in the android and ios platform files.
Running the App
Run the following command in your terminal: flutter run


Code Structure
1. Core
constants.dart: Centralized application-wide constants like topics, error messages, and default assets.
navigation.dart: Handles bottom navigation and FAB interactions.
2. Authentication
auth_controller.dart: Manages Firebase user data retrieval and state updates.
login_page.dart: Handles user login.
sign_up_page.dart: Implements user registration and Firestore profile creation.
3. Features
Home Page: Displays categories, event cards, and search functionality.
Event Page: Lists upcoming events with a search bar for filtering.
Create Post: Enables users to create and post event details.
Profile Page: Allows users to manage their profiles and sign out.
4. Models
PostModel: Defines post data structure and Firestore interactions.
UserModel: Represents user data structure and state.

Dependencies
flutter: Flutter framework support.
cupertino_icons: iOS-style icons.
firebase_core: Firebase initialization.
firebase_auth: User authentication.
cloud_firestore: Firestore database interaction.
flutter_riverpod: State management.
uuid: Unique ID generation.
  cupertino_icons: ^1.0.8
  firebase_core: ^3.8.0
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.5.0
  flutter_riverpod: ^2.6.1
  uuid: ^4.5.1

Dev Dependencies
flutter_test: Unit testing support.
flutter_lints: Code quality enforcement.

Configuration
Firebase Initialization
Set up Firebase in your project and replace the details in firebase_options.dart with your Firebase project configuration.
Constants
Update core/constants/constants.dart with:
Topics
Default error messages
Default image URLs for avatars and banners

Future Enhancements
Complete Map Integration for event discovery.
Add Notifications for event updates.
Implement Advanced Filters in the search bar for better user customization.

License
This project is private and not published on pub.dev. To publish, remove the publish_to: 'none' line from pubspec.yaml.

Authors
Syed Shayan Hussain
Alina Siddiqui
Anusha Randhawa

