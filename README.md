# 📝 Task Manager App (Flutter)

A sleek and modern Flutter task manager application that helps users organize, prioritize, and schedule tasks effectively. Built using MVVM architecture and Hive for local persistence.

## 👨‍💻 Developed by

**Muhammad Awais**

---

## 🚀 Features

- ✅ Add, edit, and delete tasks
- 🔎 Filter tasks by priority and due date
- 📅 Calendar view to visualize due tasks
- 🎨 Beautiful gradient UI with smooth animations
- 📦 Local data storage using Hive
- 🧠 Clean architecture (Domain / Data / Presentation layers)
- 🌈 Custom theming using shared app colors and typography (Poppins via Google Fonts)
- 🧩 Custom widgets to show reusability of the code

---

## 💾 Local Storage (Hive)

We use [Hive](https://pub.dev/packages/hive) for local storage. To generate the required TypeAdapters:

```bash
flutter packages pub run build_runner build
