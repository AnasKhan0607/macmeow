# Sentient Development Plan

## Phase 1: Foundation (MVP)
Get a working menu bar app with one personality module.

### Milestone 1.1: Project Setup
- [ ] Create Xcode project (menu bar app)
- [ ] Basic SwiftUI menu bar interface
- [ ] App icon and branding
- [ ] Launch at login option

### Milestone 1.2: Core Infrastructure
- [ ] Personality module protocol/architecture
- [ ] Sound playback manager
- [ ] Settings/preferences persistence
- [ ] Event bus for triggers

### Milestone 1.3: Accelerometer Integration
- [ ] IOKit HID accelerometer access
- [ ] Tilt detection
- [ ] Shake/impact detection
- [ ] Calibration

### Milestone 1.4: First Personality - Dramatic
- [ ] Implement dramatic personality module
- [ ] Sound assets (screams, gasps, complaints)
- [ ] Tilt → panic escalation
- [ ] Impact → reaction sounds

## Phase 2: Core Personalities

### Milestone 2.1: Hungry (Battery)
- [ ] Battery level monitoring
- [ ] Hunger sounds at thresholds (50%, 20%, 10%, 5%)
- [ ] Satisfaction sound when plugged in
- [ ] "Overfed" complaint at 100%

### Milestone 2.2: Judgmental (App Detection)
- [ ] NSWorkspace app launch monitoring
- [ ] Configurable "guilty pleasure" app list
- [ ] Disappointed sounds/phrases
- [ ] Cooldown to avoid spam

### Milestone 2.3: Needy (Idle/Presence)
- [ ] Idle time detection
- [ ] Lid close detection (IOKit power events)
- [ ] Absence detection via camera (optional)
- [ ] Return greeting

## Phase 3: Polish & Ship

### Milestone 3.1: Settings UI
- [ ] Full settings window
- [ ] Per-personality enable/disable toggles
- [ ] Volume control
- [ ] Sound pack selection

### Milestone 3.2: Distribution
- [ ] App signing & notarization
- [ ] DMG creation
- [ ] Landing page
- [ ] Gumroad/LemonSqueezy setup

### Milestone 3.3: Launch
- [ ] TikTok demo video
- [ ] Twitter announcement
- [ ] Reddit posts (r/macapps, r/apple)
- [ ] Product Hunt launch

## Phase 4: Monetization (Post-Launch)

### Pro Features
- [ ] Premium voice packs
- [ ] Custom sound imports
- [ ] Additional personalities (Chaotic, Romantic)
- [ ] Keyboard sound integration (like Haptyk)

---

## Technical Architecture

```
Sentient/
├── App/
│   ├── SentientApp.swift          # Entry point
│   ├── AppDelegate.swift          # Menu bar setup
│   └── StatusBarController.swift  # Menu bar management
├── Core/
│   ├── EventBus.swift             # Central event dispatcher
│   ├── SoundManager.swift         # Audio playback
│   ├── SettingsManager.swift      # UserDefaults wrapper
│   └── Personality.swift          # Protocol definition
├── Sensors/
│   ├── AccelerometerMonitor.swift # IOKit HID accelerometer
│   ├── BatteryMonitor.swift       # IOPowerSources
│   ├── AppMonitor.swift           # NSWorkspace observer
│   ├── IdleMonitor.swift          # CGEventSource idle time
│   └── LidMonitor.swift           # IOKit power events
├── Personalities/
│   ├── DramaticPersonality.swift
│   ├── HungryPersonality.swift
│   ├── JudgmentalPersonality.swift
│   └── NeedyPersonality.swift
├── UI/
│   ├── MenuBarView.swift
│   ├── SettingsView.swift
│   └── PersonalityToggle.swift
└── Resources/
    └── Sounds/
        ├── dramatic/
        ├── hungry/
        ├── judgmental/
        └── needy/
```

## Sound Assets Needed

### Dramatic
- scream_1.mp3, scream_2.mp3
- gasp_1.mp3, gasp_2.mp3
- why_would_you.mp3
- careful.mp3
- panic_escalate_1-5.mp3

### Hungry
- stomach_growl_1-3.mp3
- feed_me.mp3
- so_hungry.mp3
- ahh_satisfied.mp3
- too_full.mp3

### Judgmental
- sigh_1-3.mp3
- really.mp3
- disappointed.mp3
- again.mp3
- tsk_tsk.mp3

### Needy
- dont_leave.mp3
- miss_you.mp3
- youre_back.mp3
- sad_whimper.mp3
- hello.mp3
