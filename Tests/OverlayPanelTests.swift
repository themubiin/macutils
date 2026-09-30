// SPDX-License-Identifier: GPL-3.0-or-later
// Made with ❤️ by Muntasir Mubin

import AppKit

/// AppKit describes a non-activating panel as a system dialog, which tiling
/// window managers track and list on whichever space is current. The shared
/// panel class is compiled here and created deferred, so no window is shown;
/// each floating surface's own file is read for the class it builds.
enum OverlayPanelTests {
    static func run(_ suite: TestSuite) {
        // The Clipboard History window keeps a title bar strip to drag it by.
        for style: NSWindow.StyleMask in [[.borderless, .nonactivatingPanel],
                                          [.titled, .closable, .fullSizeContentView, .nonactivatingPanel]] {
            let overlay = OverlayPanel(contentRect: CGRect(x: 0, y: 0, width: 200, height: 40),
                                       styleMask: style, backing: .buffered, defer: true)
            suite.expect(overlay.accessibilitySubrole() == .unknown,
                         "a floating overlay describes itself as an undescribed window, so window managers skip it")
            suite.expect(overlay.accessibilityRole() == .window && overlay.isAccessibilityElement(),
                         "a floating overlay stays an accessible window for assistive technology")
        }

        // HUDs, previews, pickers and the menu's positioning helper: none is a
        // document window, and each floats over other apps' windows.
        let surfaces = [
            "Sources/MacUtils/App/AppDelegate.swift",
            "Sources/MacUtils/UI/PermissionGuideOverlay.swift",
            "Sources/MacUtils/UI/QuitProtection/QuitProtectionHUD.swift",
            "Sources/MacUtils/Services/QuickTools/QuickToolHUD.swift",
            "Sources/MacUtils/Services/QuickTools/QuickLauncherService.swift",
            "Sources/MacUtils/Services/QuickTools/CameraPreviewService.swift",
            "Sources/MacUtils/Services/QuickTools/RecentCaptureService.swift",
            "Sources/MacUtils/Services/QuickTools/ScreenshotSelectionController.swift",
            "Sources/MacUtils/Services/QuickTools/ScreenshotQuickPreviewController.swift",
            "Sources/MacUtils/Services/QuickTools/ScreenshotPinController.swift",
            "Sources/MacUtils/Services/QuickTools/QRResultController.swift",
            "Sources/MacUtils/Services/QuickTools/ScratchpadService.swift",
            "Sources/MacUtils/Services/Snippets/SnippetLibraryService.swift",
            "Sources/MacUtils/Services/Clipboard/ClipboardHistoryService.swift",
            "Sources/MacUtils/Services/CommandBar/CommandBarService.swift",
            "Sources/MacUtils/Services/Switcher/AppSwitcher.swift",
            "Sources/MacUtils/Services/RadialMenu/RadialMenuService.swift",
            "Sources/MacUtils/Services/RadialMenu/RadialNowPlayingService.swift",
            "Sources/MacUtils/Services/DockPreview/DockPreviewService.swift",
            "Sources/MacUtils/Services/WindowLayout/WindowLayoutService.swift",
            "Sources/MacUtils/Services/DiskImageInstaller/DiskImageInstallerService.swift",
            "Sources/MacUtils/Services/Finder/FinderCutPaste.swift",
            "Sources/MacUtils/Services/Display/BrightnessOSD.swift",
            "Sources/MacUtils/Services/CleaningMode/CleaningModeManager.swift",
            "Sources/MacUtils/Services/Recorder/RecorderIndicator.swift",
        ]
        for path in surfaces {
            let source = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
            suite.expect(source.range(of: #"\bOverlayPanel\(contentRect|:\s*OverlayPanel\b"#,
                                      options: .regularExpression) != nil
                         && !source.contains("NSPanel(contentRect")
                         && source.range(of: #"class \w+:\s*NSPanel\b"#, options: .regularExpression) == nil,
                         "\(path) builds its floating panels as overlays, which window managers do not list")
        }
    }
}
