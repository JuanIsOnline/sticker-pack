# iOS Sticker Packs Monorepo 🐶✨

A collection of custom, standalone iOS / iMessage Sticker Pack applications for Apple Messages by Juan Haber.

---

## 📦 Available Sticker Packs

| Pack | Folder | Bundle Identifier | Status |
| :--- | :--- | :--- | :--- |
| **L & Goku** | [`LAndGoku/`](LAndGoku/) | `com.juan.LandGoku` | App Store Review / Live |

---

## 📁 Repository Structure

```text
sticker-pack/
├── LAndGoku/                          # Pack 1 (Self-Contained)
│   ├── LAndGoku.xcodeproj             # Xcode Project
│   ├── LAndGoku/                      # Main App target
│   ├── LAndGoku StickerPackExtension/ # Stickers asset catalog & icons
│   ├── source-stickers/               # 15 individual PNG source stickers
│   ├── raw-assets/                    # Raw composites & screenshots
│   └── screenshots/                   # App Store formatted screenshots
│       ├── imessage_iphone/           # iPhone 6.5"/6.7" (1284x2778)
│       └── imessage_ipad/             # iPad 13" (2048x2732)
│
├── tools/                             # Automation & asset generation tools
│   ├── generate_icons.swift           # Generates all 13 iMessage App Icon sizes
│   └── format_screenshots.swift       # Formats screenshots to exact App Store dimensions
│
├── PRIVACY_POLICY.md                  # Global Privacy Policy (linked on App Store Connect)
├── .gitignore                         # Xcode & macOS ignore rules
└── README.md                          # Repository hub & documentation
```

---

## 🛠️ How to Add a New Sticker Pack

When creating a new sticker pack in this repo:

1. **Create the Project in Xcode:**
   - In Xcode: **File > New > Project > iOS > Sticker Pack App**.
   - Save it directly into the root folder (e.g. `sticker-pack/YourPackName/`).
2. **Add Your PNG Stickers:**
   - Drag your transparent PNGs into `Stickers.xcstickers > Sticker Pack`.
   - Save copies in `YourPackName/source-stickers/`.
3. **Auto-Generate All App Icon Sizes (5 seconds):**
   ```bash
   swift tools/generate_icons.swift <path-to-cover-sticker.png> "YourPackName/YourPackName StickerPackExtension/Stickers.xcstickers/iMessage App Icon.stickersiconset"
   ```
4. **Auto-Generate App Store Screenshots (5 seconds):**
   ```bash
   swift tools/format_screenshots.swift <messages-screenshot.png> <stickers-poster.png> "YourPackName/screenshots"
   ```
5. **Build & Distribute:**
   - Open the `.xcodeproj` in Xcode.
   - Archive and upload to App Store Connect / TestFlight!

---

## 🔒 Privacy Policy
All sticker packs in this repository adhere to the [Privacy Policy](PRIVACY_POLICY.md) (Zero data collection / tracking).

---

## 📄 License
© 2026 Juan Haber. All rights reserved.
