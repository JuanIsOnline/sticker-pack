import Cocoa

// Usage: swift generate_icons.swift <path-to-source-image.png> <path-to-stickersiconset-folder>
let args = CommandLine.arguments

guard args.count >= 3 else {
    print("Usage: swift generate_icons.swift <source-image.png> <destination-stickersiconset-folder>")
    exit(1)
}

let sourcePath = args[1]
let destDir = args[2]

guard let sourceImage = NSImage(contentsOfFile: sourcePath) else {
    print("Error: Could not load source image at '\(sourcePath)'")
    exit(1)
}

try? FileManager.default.createDirectory(atPath: destDir, withIntermediateDirectories: true, attributes: nil)

struct IconSpec {
    let filename: String
    let idiom: String
    let size: String
    let scale: String
    let width: CGFloat
    let height: CGFloat
    let platform: String?
}

let specs: [IconSpec] = [
    IconSpec(filename: "icon_iphone_29x29@2x.png", idiom: "iphone", size: "29x29", scale: "2x", width: 58, height: 58, platform: nil),
    IconSpec(filename: "icon_iphone_29x29@3x.png", idiom: "iphone", size: "29x29", scale: "3x", width: 87, height: 87, platform: nil),
    IconSpec(filename: "icon_iphone_60x45@2x.png", idiom: "iphone", size: "60x45", scale: "2x", width: 120, height: 90, platform: nil),
    IconSpec(filename: "icon_iphone_60x45@3x.png", idiom: "iphone", size: "60x45", scale: "3x", width: 180, height: 135, platform: nil),
    IconSpec(filename: "icon_ipad_29x29@2x.png", idiom: "ipad", size: "29x29", scale: "2x", width: 58, height: 58, platform: nil),
    IconSpec(filename: "icon_ipad_67x50@2x.png", idiom: "ipad", size: "67x50", scale: "2x", width: 134, height: 100, platform: nil),
    IconSpec(filename: "icon_ipad_74x55@2x.png", idiom: "ipad", size: "74x55", scale: "2x", width: 148, height: 110, platform: nil),
    IconSpec(filename: "icon_marketing_1024x1024.png", idiom: "ios-marketing", size: "1024x1024", scale: "1x", width: 1024, height: 1024, platform: nil),
    IconSpec(filename: "icon_universal_27x20@2x.png", idiom: "universal", size: "27x20", scale: "2x", width: 54, height: 40, platform: "ios"),
    IconSpec(filename: "icon_universal_27x20@3x.png", idiom: "universal", size: "27x20", scale: "3x", width: 81, height: 60, platform: "ios"),
    IconSpec(filename: "icon_universal_32x24@2x.png", idiom: "universal", size: "32x24", scale: "2x", width: 64, height: 48, platform: "ios"),
    IconSpec(filename: "icon_universal_32x24@3x.png", idiom: "universal", size: "32x24", scale: "3x", width: 96, height: 72, platform: "ios"),
    IconSpec(filename: "icon_marketing_1024x768.png", idiom: "ios-marketing", size: "1024x768", scale: "1x", width: 1024, height: 768, platform: "ios")
]

var jsonImages: [[String: Any]] = []

for spec in specs {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(spec.width),
        pixelsHigh: Int(spec.height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!
    
    NSGraphicsContext.saveGraphicsState()
    let context = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current = context
    
    // Solid background (white)
    NSColor.white.setFill()
    NSRect(x: 0, y: 0, width: spec.width, height: spec.height).fill()
    
    // Draw centered with gentle padding
    let padding: CGFloat = 0.88
    let maxDrawW = spec.width * padding
    let maxDrawH = spec.height * padding
    
    let srcW = sourceImage.size.width
    let srcH = sourceImage.size.height
    let scale = min(maxDrawW / srcW, maxDrawH / srcH)
    let drawW = srcW * scale
    let drawH = srcH * scale
    let drawX = (spec.width - drawW) / 2.0
    let drawY = (spec.height - drawH) / 2.0
    
    sourceImage.draw(in: NSRect(x: drawX, y: drawY, width: drawW, height: drawH),
                     from: NSRect(x: 0, y: 0, width: srcW, height: srcH),
                     operation: .sourceOver,
                     fraction: 1.0)
    
    NSGraphicsContext.restoreGraphicsState()
    
    let pngData = rep.representation(using: .png, properties: [:])!
    let outUrl = URL(fileURLWithPath: destDir).appendingPathComponent(spec.filename)
    try! pngData.write(to: outUrl)
    print("  ✓ Generated \(spec.filename) (\(Int(spec.width))x\(Int(spec.height)))")
    
    var imgDict: [String: Any] = [
        "filename": spec.filename,
        "idiom": spec.idiom,
        "scale": spec.scale,
        "size": spec.size
    ]
    if let platform = spec.platform {
        imgDict["platform"] = platform
    }
    jsonImages.append(imgDict)
}

let contentsJson: [String: Any] = [
    "images": jsonImages,
    "info": [
        "author": "xcode",
        "version": 1
    ]
]

let jsonData = try! JSONSerialization.data(withJSONObject: contentsJson, options: [.prettyPrinted, .sortedKeys])
let contentsUrl = URL(fileURLWithPath: destDir).appendingPathComponent("Contents.json")
try! jsonData.write(to: contentsUrl)
print("  ✓ Updated Contents.json")
