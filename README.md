# 🎓 TNPSC AI Assistant

**Offline AI Assistant for TNPSC & Competitive Exam Preparation**

A modern, professional Flutter Android application that helps students prepare for TNPSC and competitive exams with an on-device AI assistant.

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🤖 **AI Chatbot** | ChatGPT-style offline assistant for doubts |
| 📊 **Aptitude** | Percentages, Profit/Loss, Time & Work + 8 more |
| 🧩 **Reasoning** | Blood Relations, Number Series, Puzzles + 6 more |
| 📝 **Verbal** | Grammar, Synonyms, Antonyms + 5 more |
| 📰 **Current Affairs** | Monthly updates with daily quiz |
| 📋 **Mock Tests** | Timed TNPSC-style practice exams |
| 📈 **Progress** | Analytics dashboard with accuracy tracking |
| 📄 **PDF Assistant** | Upload notes, ask questions, get AI summaries |
| 🔊 **Voice** | Text-to-Speech for answers |
| 🌙 **Dark Mode** | Full dark/light theme support |

## 🛠️ Tech Stack

- **Frontend:** Flutter 3.22+ / Dart
- **Database:** SQLite (sqflite)
- **AI Engine:** Pattern-matching (upgradeable to MediaPipe/llama.cpp)
- **State:** Riverpod
- **Architecture:** Clean Architecture + MVVM

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp
├── config/theme/                # Colors, themes, typography
├── config/routes/               # Navigation
├── core/database/               # SQLite helper
├── core/services/               # AI, TTS, PDF, Question loader
├── core/providers/              # Riverpod state
├── features/                    # 12 feature modules, 15 screens
├── models/                      # Data models
└── widgets/                     # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.22+
- Android Studio + SDK 34
- Java JDK 17+

### Setup
```bash
flutter pub get
flutter run
```

### Build APK
```bash
flutter build apk --release --split-per-abi
```

## 📱 Screens

Splash → Login → Register → Dashboard → AI Chat → Aptitude → Topic Quiz → Reasoning → Verbal → Current Affairs → Mock Test → Results → Progress → PDF Assistant → Settings

## 📊 Database

10 SQLite tables: users, questions, user_answers, chat_messages, mock_tests, current_affairs, bookmarks, user_progress, achievements, pdf_notes

## 🤖 AI Integration

Currently uses pattern-matching for instant offline responses. Upgrade path:
1. **MediaPipe LLM** → Gemma 2B (recommended)
2. **llama.cpp FFI** → TinyLlama / Phi-3 Mini

## 📄 License

MIT License - Free for educational use.
