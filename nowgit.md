# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | Volarm |
| **Git URL** | git@github.com:asunnyboy861/Volarm.git |
| **Repo URL** | https://github.com/asunnyboy861/Volarm |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/Volarm/ | ✅ Active |
| Support | https://asunnyboy861.github.io/Volarm/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/Volarm/privacy.html | ✅ Active |

**Note**: Terms of Use not required for one-time purchase apps. Only Support + Privacy needed.

## Repository Structure

```
Volarm/
├── Volarm/                           # iOS App Source Code
│   ├── Volarm.xcodeproj/             # Xcode Project
│   ├── Volarm/                       # Swift Source Files
│   │   ├── Views/
│   │   │   ├── AlarmListView.swift
│   │   │   ├── AlarmEditView.swift
│   │   │   ├── OnboardingView.swift
│   │   │   ├── SettingsView.swift
│   │   │   ├── ContactSupportView.swift
│   │   │   └── Components/
│   │   ├── Models/
│   │   │   └── AlarmModel.swift
│   │   ├── Services/
│   │   │   ├── AlarmScheduler.swift
│   │   │   ├── VolumeManager.swift
│   │   │   ├── SoundManager.swift
│   │   │   └── PurchaseManager.swift
│   │   ├── Metadata/
│   │   │   └── VolarmMetadata.swift
│   │   ├── Extensions/
│   │   │   └── Color+Hex.swift
│   │   ├── Intents/
│   │   │   ├── StopAlarmIntent.swift
│   │   │   └── SnoozeAlarmIntent.swift
│   │   ├── ContentView.swift
│   │   └── VolarmApp.swift
│   └── Assets.xcassets/
├── docs/                             # Policy Pages (GitHub Pages source)
│   ├── index.html                    # Landing Page
│   ├── support.html                  # Support Page
│   └── privacy.html                  # Privacy Policy
├── .github/workflows/
│   └── deploy.yml                    # GitHub Pages deployment
├── us.md                             # English Development Guide
├── keytext.md                        # App Store Metadata
├── capabilities.md                   # Capabilities Configuration
├── icon.md                           # App Icon Details
├── price.md                          # Pricing Configuration
└── nowgit.md                         # This File
```
