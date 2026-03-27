# Sentient 🧠

**Your Mac is alive now.**

A macOS menu bar app that gives your MacBook a personality. It reacts to how you treat it — tilt it, ignore it, drain its battery, or doom-scroll on Reddit. Your Mac now has feelings about all of it.

## Features

| Personality | Triggers | Reactions |
|-------------|----------|-----------|
| 🎭 **Dramatic** | Tilt, slam, shake | Screams, gasps, "why would you do this?!" |
| 🥺 **Needy** | Idle too long, close lid | "Don't leave me", sad sounds, guilt trips |
| 😤 **Judgmental** | Opens Twitter/Reddit/TikTok | Sighs, "really?", disappointed parent vibes |
| 🍔 **Hungry** | Battery < 20% | Stomach growls, weakness, "feed me..." |
| 😴 **Sleepy** | Idle, lid closing | Yawns, snoring sounds, "finally, rest" |
| 🎲 **Chaotic** | Random intervals | Unhinged outbursts, giggles, chaos |
| 💕 **Romantic** | Plugged in, returns after absence | "I missed you", romantic music stings |

## Installation

### Direct Download (Recommended)
Download the latest `.dmg` from [Releases](https://github.com/AnasKhan0607/sentient/releases).

### Build from Source
```bash
git clone https://github.com/AnasKhan0607/sentient.git
cd sentient
open Sentient.xcodeproj
# Build with ⌘B, Run with ⌘R
```

## Requirements

- macOS 13.0+ (Ventura or later)
- Apple Silicon Mac (M1/M2/M3/M4) for accelerometer features
- Camera access (optional, for presence detection)

## Tech Stack

- Swift 5.9+
- SwiftUI
- CoreMotion / IOKit (accelerometer)
- Vision framework (face detection)
- NSWorkspace (app monitoring)
- IOPowerSources (battery)

## Privacy

Sentient runs 100% locally. No data leaves your Mac. Camera is only used for presence detection (optional) and frames are never stored or transmitted.

## Roadmap

- [x] Project setup
- [ ] Core accelerometer integration
- [ ] Menu bar UI
- [ ] Dramatic personality
- [ ] Hungry personality (battery)
- [ ] Judgmental personality (app detection)
- [ ] Needy personality
- [ ] Settings persistence
- [ ] Custom sound packs
- [ ] Pro version with premium voices

## Contributing

PRs welcome! Check the [Issues](https://github.com/AnasKhan0607/sentient/issues) for what needs doing.

## License

MIT License. Go wild.

---

*Made by [Anas Khan](https://twitter.com/AnasKhan0607)*
