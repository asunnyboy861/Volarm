# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- AlarmKit (system-level alarm scheduling) — detected from "闹钟", "AlarmKit", "系统级闹钟"
- Audio Playback (AVAudioPlayer for independent volume) — detected from "音量", "AVAudioPlayer"
- In-App Purchase (one-time Pro upgrade) — detected from "付费", "Pro", "买断"
- Widgets (WidgetKit) — detected from "小组件", "WidgetKit"
- Live Activities (ActivityKit) — detected from "灵动岛", "Dynamic Island"
- App Intents (Siri/Shortcuts) — detected from "Siri", "快捷指令"
- Background Audio — detected from "音频播放", "AVAudioSession"

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| AlarmKit | ✅ Configured | Info.plist NSAlarmKitUsageDescription |
| Audio Playback | ✅ Configured | AVFoundation framework import |
| Background Modes (Audio) | ✅ Configured | Xcode capability |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| In-App Purchase | ⏳ Pending | 1. Open Xcode > Signing & Capabilities > + Capability > In-App Purchase. 2. Create StoreKit Configuration file for testing. 3. Configure product ID: com.zzoutuo.Volarm.pro in App Store Connect. |
| WidgetKit | ⏳ Pending | 1. Add Widget Extension target in Xcode. 2. Configure widget timeline provider. 3. Design widget views. |
| ActivityKit (Live Activities) | ⏳ Pending | 1. Add NSSupportsLiveActivities = YES to Info.plist. 2. Create ActivityAttributes model. 3. Implement Live Activity views. |
| App Intents | ⏳ Pending | 1. Create AppIntent structs for Stop/Snooze actions. 2. Register intents in app configuration. 3. Test with Siri. |

## No Configuration Needed
- HealthKit — not required for alarm volume control
- Location Services — not required
- Camera / Photo Library — not required
- iCloud / CloudKit — optional, not required for MVP
- Push Notifications — AlarmKit handles alarm delivery
- Sign in with Apple — not required

## Verification
- Build succeeded after configuration: ⏳ Pending (will verify after code generation)
- All entitlements correct: ⏳ Pending
