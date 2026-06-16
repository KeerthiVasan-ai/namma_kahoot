<div align="center">
  <h1>Namma Kahoot</h1>
  
  <p>
    <strong>The open-source real-time quiz and interactive learning platform.</strong>
  </p>

  <p>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter" alt="Platform"></a>
    <a href="https://dart.dev"><img src="https://img.shields.io/badge/Language-Dart-0175C2?logo=dart" alt="Language"></a>
    <a href="https://serverpod.dev"><img src="https://img.shields.io/badge/Backend-Serverpod-FF4081?logo=dart" alt="Backend"></a>
    <a href="https://github.com/schultek/jaspr"><img src="https://img.shields.io/badge/Web-Jaspr-FF9800" alt="Jaspr"></a>
    <a href="https://github.com/KeerthiVasan-ai/namma_kahoot/blob/main/LICENSE"><img src="https://img.shields.io/github/license/KeerthiVasan-ai/namma_kahoot" alt="License"></a>
    <a href="https://github.com/KeerthiVasan-ai/namma_kahoot/stargazers"><img src="https://img.shields.io/github/stars/KeerthiVasan-ai/namma_kahoot?style=social" alt="Stars"></a>
  </p>
</div>

---

## 🌟 Overview

**Namma Kahoot** is an open-source, real-time interactive learning application built entirely in **Dart**. Whether you're hosting a quiz for a classroom, a corporate event, or a fun night with friends, Namma Kahoot provides a seamless, high-performance, and beautiful experience across all platforms.

Inspired by industry leaders, Namma Kahoot leverages the full power of the Dart ecosystem to deliver a unified, full-stack solution.

## ✨ Key Features

- ⚡ **Real-time Synchronization:** Ultra-low latency game state synchronization using WebSockets.
- 📱 **Cross-Platform:** Native mobile and desktop experiences powered by **Flutter**.
- 🌐 **High-Performance Web:** SEO-friendly, blazingly fast web client built with **Jaspr**.
- 🚀 **Scalable Backend:** Robust backend architecture built on **Serverpod** with PostgreSQL and Redis.
- 🎨 **Beautiful UI:** Polished, modern user interface with smooth micro-animations and dynamic layouts.
- 🔒 **Secure:** Enterprise-grade security and authentication out of the box.

## 🏗️ Architecture

Namma Kahoot is designed as a modern monorepo, separating concerns while sharing a single underlying language: Dart.

- **`namma_kahoot_server`**: The brain of the operation. A scalable Serverpod backend handling real-time WebSockets, database interactions, and Redis caching.
- **`namma_kahoot_client`**: The auto-generated Serverpod client, sharing data models and protocol definitions across the entire workspace.
- **`namma_kahoot_flutter`**: The beautifully crafted mobile and desktop application.
- **`namma_kahoot_jaspr`**: The lightweight, highly optimized web application tailored for browsers.

---

## 🚀 Getting Started

Follow these steps to get your local development environment up and running.

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) (^3.8.0)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Docker](https://www.docker.com/products/docker-desktop) (for local database & Redis)
- [Serverpod CLI](https://docs.serverpod.dev/)
- [Jaspr CLI](https://pub.dev/packages/jaspr_cli)

### 1. Start the Infrastructure (Docker)

Start the PostgreSQL and Redis instances in the background:

```bash
cd namma_kahoot_server
docker compose up --build --detach
```

### 2. Start the Backend Server

Ensure database migrations are applied and start the Serverpod backend:

```bash
cd namma_kahoot_server
dart bin/main.dart --apply-migrations
```

### 3. Run the Web UI (Jaspr)

In a new terminal window, start the Jaspr development server with hot-reload:

```bash
cd namma_kahoot_jaspr
jaspr serve
```

### 4. Run the Mobile/Desktop App (Flutter)

In a new terminal window, start the Flutter companion app:

```bash
cd namma_kahoot_flutter
flutter run
```

*For a full list of commands, check out our [Commands Cheat Sheet](./COMMANDS.md).*

---

## 🤝 Contributing

We welcome contributions from the community! Whether it's fixing a bug, improving documentation, or proposing a new feature, your help is appreciated.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 🛡️ License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

<div align="center">
  <sub>Built with ❤️</sub>
</div>
