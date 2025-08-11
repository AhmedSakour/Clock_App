# 🕒 Flutter Clock App

A beautiful and functional **Clock App** built with **Flutter**, featuring:

- **Analog/Digital Clock**
- **Alarms** (with native Kotlin implementation)
- **Stopwatch**
- **Timer**

Data is persisted using **sqflite**, and app state is managed with **flutter_riverpod**.  
Alarms are implemented natively in **Kotlin** for reliable background execution.

---

## 📱 Features

### ⏰ Alarm
- Add, edit, and delete alarms.
- Stores alarms locally using **sqflite**.
- Native Kotlin alarm service for precise scheduling and background notifications.

### 🕓 Clock
- Real-time analog and digital clock display.

### ⏱ Stopwatch
- Start, pause, reset stopwatch.
- Tracks elapsed time accurately even in background.

### ⌛ Timer
- Set countdown timers with custom durations.

---

## 🛠 Tech Stack

- **Flutter** — UI framework
- **Kotlin** — Native Android alarm handling
- **flutter_riverpod** — State management
- **sqflite** — Local data storage
- **Android AlarmManager** — Alarm scheduling

---


## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio or VS Code
- Git

### Installation
```bash
# Clone the repository
git clone https://github.com/AhmedSakour/Clock_App

# Navigate into the project
cd Clock_App

# Install dependencies
flutter pub get

# Run the app
flutter run
```
---


 📸 Screenshots

| Clock | Alarm | Stopwatch | Timer |
|-------|-------|-------|-------|
| <img src="assets/images/clock-portrait.png" height="400"/> | <img src="assets/images/alarm-portrait.png" height="400"/> | <img src="assets/images/stop_watch-portrait.png" height="400"/> | <img src="assets/images/timer-portrait.png" height="400"/>  |








