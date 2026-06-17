# Namma Kahoot - Commands Cheat Sheet

This document contains all the essential commands needed to run, build, and manage the Namma Kahoot application across its Server, UI, and Docker environments.

---

## 🐋 Docker (Database & Redis)

Serverpod relies on Docker to run PostgreSQL and Redis locally. You must start the Docker containers before running the server.

**Start the Docker containers (in background):**
```bash
cd namma_kahoot_server
docker compose up --build --detach
```

**Stop the Docker containers:**
```bash
cd namma_kahoot_server
docker compose down -v
```

**View Docker logs (follow mode):**
```bash
cd namma_kahoot_server
docker compose logs -f
```

---

## ⚙️ Server (Serverpod)

The backend is built with Serverpod. Ensure Docker is running before starting the server.

**Start the local server:**
```bash
cd namma_kahoot_server
dart bin/main.dart --apply-migrations
```
*(Note: `--apply-migrations` ensures the database schema is up-to-date).*

**Generate server code (after modifying protocol files):**
```bash
cd namma_kahoot_server
serverpod generate
```

**Create a new database migration (after modifying tables):**
```bash
cd namma_kahoot_server
serverpod create-migration
```

---

## 🌐 Web UI (Jaspr)

The web frontend is built with Jaspr, optimized for web deployment.

**Start the Jaspr development server (with hot-reload):**
```bash
cd namma_kahoot_jaspr
jaspr serve
```
*The web UI will typically be accessible at `http://localhost:8080`.*

**Build the Jaspr app for production:**
```bash
cd namma_kahoot_jaspr
jaspr build
```

---

## 📱 Mobile/Desktop UI (Flutter)

If you are running the companion Flutter app for mobile or desktop.

**Run the Flutter app:**
```bash
cd namma_kahoot_flutter
flutter run
```

**Generate Flutter client code (if you updated server protocols):**
```bash
# This is automatically generated when you run `serverpod generate` in the server project.
# Just ensure you run `flutter pub get` in the flutter directory afterwards.
cd namma_kahoot_flutter
flutter pub get
```
