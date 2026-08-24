import Cocoa

// Usage: swift format_screenshots.swift <messages-screenshot.png> <stickers-poster.png> <output-directory>
let args = CommandLine.arguments

guard args.count >= 4 else {
    print("Usage: swift format_screenshots.swift <messages-screenshot.png> <stickers-poster.png> <output-directory>")
    exit(1)
}

let inAppPath = args[1]
let posterPath = args[2]
let outBaseDir = args[3]

guard let inAppImage = NSImage(contentsOfFile: inAppPath),
      let posterImage = NSImage(contentsOfFile: posterPath) else {
    print("Error: Could not load source images")
    exit(1)
}

let fm = FileManager.default
let iphoneDir = URL(fileURLWithPath: outBaseDir).appendingPathComponent("imessage_iphone").path
let ipadDir = URL(fileURLWithPath: outBaseDir).appendingPathComponent("imessage_ipad").path

try? fm.createDirectory(atPath: iphoneDir, withIntermediateDirectories: true, attributes: nil)
try? fm.createDirectory(atPath: ipadDir, withIntermediateDirectories: true, attributes: nil)

func renderResized(image: NSImage, targetW: CGFloat, targetH: CGFloat, destPath: String, fitAspect: Bool = false) {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(targetW),
        pixelsHigh: Int(targetH),
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
    
    NSColor.white.setFill()
    NSRect(x: 0, y: 0, width: targetW, height: targetH).fill()
    
    if fitAspect {
        let maxW = targetW * 0.92
        let maxH = targetH * 0.92
        let scale = min(maxW / image.size.width, maxH / image.size.height)
        let drawW = image.size.width * scale
        let drawH = image.size.height * scale
        let drawX = (targetW - drawW) / 2.0
        let drawY = (targetH - drawH) / 2.0
        image.draw(in: NSRect(x: drawX, y: drawY, width: drawW, height: drawH),
                   from: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height),
                   operation: .sourceOver,
                   fraction: 1.0)
    } else {
        image.draw(in: NSRect(x: 0, y: 0, width: targetW, height: targetH),
                   from: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height),
                   operation: .sourceOver,
                   fraction: 1.0)
    }
    
    NSGraphicsContext.restoreGraphicsState()
    
    let pngData = rep.representation(using: .png, properties: [:])!
    try! pngData.write(to: URL(fileURLWithPath: destPath))
    print("  ✓ Saved \(URL(fileURLWithPath: destPath).lastPathComponent) (\(Int(targetW))x\(Int(targetH)))")
}

print("Generating iPhone iMessage Screenshots (1284x2778)...")
renderResized(image: inAppImage, targetW: 1284, targetH: 2778, destPath: "\(iphoneDir)/screenshot_1_messages_1284x2778.png")
renderResized(image: posterImage, targetW: 1284, targetH: 2778, destPath: "\(iphoneDir)/screenshot_2_stickers_1284x2778.png", fitAspect: true)

print("Generating iPad 13\" iMessage Screenshots (2048x2732)...")
renderResized(image: inAppImage, targetW: 2048, targetH: 2732, destPath: "\(ipadDir)/ipad_screenshot_1_messages_2048x2732.png", fitAspect: true)
renderResized(image: posterImage, targetW: 2048, targetH: 2732, destPath: "\(ipadDir)/ipad_screenshot_2_stickers_2048x2732.png", fitAspect: true)

print("Done formatting screenshots.")
