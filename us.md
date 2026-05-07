# Volarm - iOS Development Guide

## Executive Summary

Volarm is a per-alarm volume control app for iOS 26+ that solves the #1 complaint about iPhone alarms: the inability to set different volumes for different alarms. Powered by Apple's new AlarmKit framework, Volarm delivers system-level alarm reliability with independent volume control for each alarm.

**Product Vision**: Every alarm deserves its own volume. A gentle 20% wake-up on weekends, a blaring 100% on workdays, and a soft 30% for naps — all without touching the system ringer volume.

**Target Audience**: US iPhone users who rely on multiple alarms daily — couples with different schedules, power nappers, professionals with varied routines, and anyone who has ever overslept because they turned down their media volume.

**Key Differentiators**:
- Volume color coding system (Blue/Green/Orange/Red) for instant visual recognition
- Gradual volume ramp-up for gentle wake-ups
- One-time purchase model ($4.99) vs. competitor subscriptions ($4.99/month)
- System-level reliability via AlarmKit (breaks through Silent Mode, Focus Mode)
- Dynamic Island and Apple Watch integration

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| **VariAlarm** | First-mover with per-alarm volume, uses AlarmKit, iOS 26 native | Limited volume presets (0%/20%/60%/100%), no gradual volume, no color coding, no custom sounds | Volarm offers continuous volume slider, gradual ramp-up, color-coded volume system, custom sound import, and richer feature set |
| **Alarmy** | Strong brand, task-based wake-up, 4.6 rating | No per-alarm volume, bloated features, $4.99/month subscription, battery drain | Volarm is focused on volume control, one-time purchase, lightweight |
| **iOS Clock (Native)** | System-level, free, reliable | Volume tied to ringer, no per-alarm volume, no gradual volume | Volarm provides independent per-alarm volume with visual coding |
| **Headphone Alarm** | 100-step volume control, headphone-only mode | Single alarm only, no repeating schedule, outdated UI, no AlarmKit | Volarm supports unlimited alarms, repeating schedules, modern SwiftUI |
| **ZenMode** | Beautiful dark UI, gentle alarms, sleep tracking | No per-alarm volume, subscription model, focus on sleep not volume | Volarm focuses specifically on volume differentiation |

**Market Gap**: While VariAlarm exists as a direct competitor, it offers limited volume presets rather than a continuous slider, lacks gradual volume ramp-up, and has no visual volume coding system. Volarm provides a more polished, feature-rich experience with a superior UX.

## Apple Design Guidelines Compliance

- **AlarmKit Authorization**: Request permission with clear NSAlarmKitUsageDescription explaining why the app needs alarm access
- **HIG - Alerts**: Alarm alerts are prominent and clear, showing alarm name and app name with Stop/Snooze actions
- **HIG - Live Activities**: Use ActivityKit for Dynamic Island countdown display during snooze
- **HIG - Widgets**: Provide Home Screen and Lock Screen widgets showing next alarm time and volume level
- **HIG - Accessibility**: Full VoiceOver support, Dynamic Type, high contrast volume colors
- **HIG - Dark Mode**: Pure black background (#000000) for OLED-friendly display, system gray cards
- **App Store Review Guidelines 2.5.4**: AlarmKit requires proper entitlement; ensure NSAlarmKitUsageDescription is set
- **Privacy**: All data stored locally via SwiftData, no server communication, no tracking

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), AlarmKit (system alarms), AVFoundation (audio playback)
- **Data**: SwiftData with @Model classes
- **Audio**: AVAudioPlayer + AVAudioSession for independent volume control
- **Widgets**: WidgetKit for Home Screen and Lock Screen
- **Live Activities**: ActivityKit for Dynamic Island countdown
- **Intents**: App Intents for Siri and Shortcuts integration
- **Monetization**: StoreKit 2 for one-time in-app purchase

## Module Structure

```
Volarm/
├── VolarmApp.swift
├── Models/
│   └── AlarmModel.swift
├── Services/
│   ├── AlarmScheduler.swift
│   ├── VolumeManager.swift
│   ├── SoundManager.swift
│   └── PurchaseManager.swift
├── Views/
│   ├── AlarmListView.swift
│   ├── AlarmEditView.swift
│   ├── OnboardingView.swift
│   ├── SettingsView.swift
│   ├── ContactSupportView.swift
│   └── Components/
│       ├── VolumeSliderView.swift
│       ├── VolumeIndicatorView.swift
│       ├── DayPickerView.swift
│       ├── SoundPickerView.swift
│       └── AlarmCardView.swift
├── Intents/
│   ├── StopAlarmIntent.swift
│   └── SnoozeAlarmIntent.swift
├── Metadata/
│   └── VolarmMetadata.swift
└── Widgets/
    ├── VolarmWidget.swift
    └── VolarmLiveActivity.swift
```

## Implementation Flow

1. Configure Xcode project: Bundle ID, Info.plist (NSAlarmKitUsageDescription), AlarmKit capability
2. Create data model: AlarmModel with SwiftData including volume, sound, schedule fields
3. Implement AlarmScheduler: AlarmKit wrapper for scheduling, stopping, snoozing alarms
4. Implement VolumeManager: AVAudioPlayer + AVAudioSession for independent volume per alarm
5. Create VolarmMetadata: AlarmMetadata protocol implementation for AlarmKit
6. Build AlarmListView: List of alarms with volume color indicators and toggle switches
7. Build AlarmEditView: Create/edit alarm with time picker, volume slider, sound picker, day picker
8. Build VolumeSliderView: Custom slider with color gradient (Blue→Green→Orange→Red)
9. Implement PurchaseManager: StoreKit 2 one-time purchase for Pro upgrade
10. Build SettingsView: App settings, policy links, restore purchases, contact support
11. Build OnboardingView: First-launch guide explaining per-alarm volume concept
12. Create App Intents: Stop and Snooze actions for AlarmKit integration
13. Add WidgetKit support: Home Screen widget showing next alarm + volume
14. Add ActivityKit support: Dynamic Island countdown during snooze
15. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**:
  - Background (Dark): #000000 (OLED black)
  - Card Background (Dark): #1C1C1E (iOS system gray)
  - Primary Text: #FFFFFF
  - Secondary Text: #8E8E93
  - Volume Blue (Quiet 0-30%): #0A84FF
  - Volume Green (Medium 30-60%): #30D158
  - Volume Orange (Loud 60-80%): #FF9F0A
  - Volume Red (Max 80-100%): #FF453A
  - Divider: #38383A
  - Background (Light): #F2F2F7
  - Card Background (Light): #FFFFFF

- **Typography**: iOS system font (SF Pro), rounded design for volume percentages
- **Layout**: Card-based alarm list, form-based edit view, max-width 720pt for iPad
- **Animations**: Color gradient transition on volume slider, haptic feedback per 10% step, elastic toggle animation, pulse animation on volume preview

## Code Generation Rules

- Architecture: MVVM pattern, View does not directly access data layer
- Naming: Model suffix "Model", View suffix "View", Manager suffix "Manager"
- Concurrency: All AlarmKit calls must be in @MainActor context
- Error handling: Use async/await + try/catch, no optional try
- Volume range: Float 0.0-1.0, UI displays as 0%-100%
- Volume colors: 0-30% blue, 30-60% green, 60-80% orange, 80-100% red
- Data validation: Alarm name not empty, at least one day selected, volume 0-1
- Audio session: Use .playback category with .mixWithOthers option
- No comments in code unless explicitly requested
- All SwiftData model attributes must be optional or have default values

## Build & Deployment Checklist

- [ ] Xcode project configured with com.zzoutuo.Volarm bundle ID
- [ ] Info.plist includes NSAlarmKitUsageDescription
- [ ] AlarmKit capability enabled in project settings
- [ ] SwiftData model compiles without errors
- [ ] AlarmKit authorization flow works correctly
- [ ] AVAudioPlayer plays at correct volume per alarm
- [ ] StoreKit 2 purchase flow tested
- [ ] Build succeeds on iPhone simulator
- [ ] Build succeeds on iPad simulator
- [ ] No API keys or secrets in source code
- [ ] Policy pages deployed to GitHub Pages
- [ ] App Store metadata prepared (keytext.md)
