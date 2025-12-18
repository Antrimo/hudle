# Hudle flutter assignment

A simple and clean Flutter weather app that allows users to search for a city and view real-time weather information such as temperature, condition, humidity, and wind speed.  
The app follows **BLoC architecture**, uses **Dio for API calls**, and supports **light/dark mode**, **pull-to-refresh**, and **local caching**.

## features implemented

- Search weather by city name
- Display:
  - City name
  - Temperature (Celsius / Fahrenheit toggle)
  - Weather condition
  - Humidity & wind speed
- BLoC pattern using `flutter_bloc`
- API integration using `Dio`
- Pull to refresh (Liquid Pull Refresh)
- Light / Dark mode
- Cache last searched weather locally
- Lottie animations based on weather


## architecture & structure

```
lib/
├── core/
│   ├── constants/
|   ├── theme/
│   └── utils/
│
├── bloc/
| 
├── data/
|       ├── local/
│       ├── models/
|       ├── repository/
│       └── services/
|
├── presentation/
│           ├── screens/
│           └── widgets/             
│
└── main.dart
```

## How I Learned & Used BLoC

My learning approach:
- Studied how **Events → BLoC → States** work together
- Practiced emitting states like `Loading`, `Success`, and `Failure`
- Started with learning `Cubit` and then shifting to `Bloc`
- Followed few articles and tutorials for learning. 


In this project:
- **Events** handle user actions (search, refresh, toggle modes)
- **Bloc** coordinates repository calls and state transitions
- **States** represent UI conditions (loading, success, failure)

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/Antrimo/hudle.git
cd hudle
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3 Run app
```bash
flutter run
```

## Challenges faced

As I was leaning bloc, I had confusion with the structure flow and coordination of the `Bloc` to the `Repository`. There I used AI to understand the flow and how to approach it.
