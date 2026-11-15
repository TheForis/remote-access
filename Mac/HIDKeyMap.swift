import CoreGraphics

/// USB HID Keyboard/Keypad page (0x07) usage -> macOS virtual key code, for
/// the `key` wire message (PROTOCOL.md 6.1). The wire names the physical key,
/// so this is the ANSI position table; the Mac's active layout then decides
/// which character that position produces, as it would for a real keyboard.
enum HIDKeyMap {
    static func virtualKey(forUsage usage: Int) -> CGKeyCode? {
        table[usage]
    }

    /// The modifier flag a virtual key contributes while held, if it is one.
    static func modifierFlag(forVirtualKey key: CGKeyCode) -> CGEventFlags? {
        switch key {
        case 59, 62: return .maskControl
        case 56, 60: return .maskShift
        case 58, 61: return .maskAlternate
        case 55, 54: return .maskCommand
        default: return nil
        }
    }

    private static let table: [Int: CGKeyCode] = {
        var t: [Int: CGKeyCode] = [:]
        // 0x04...0x1D: a...z
        let letters: [CGKeyCode] = [0, 11, 8, 2, 14, 3, 5, 4, 34, 38, 40, 37, 46,
                                    45, 31, 35, 12, 15, 1, 17, 32, 9, 13, 7, 16, 6]
        for (i, code) in letters.enumerated() { t[0x04 + i] = code }
        // 0x1E...0x27: 1...9, 0
        let digits: [CGKeyCode] = [18, 19, 20, 21, 23, 22, 26, 28, 25, 29]
        for (i, code) in digits.enumerated() { t[0x1E + i] = code }
        // 0x3A...0x45: F1...F12
        let fkeys: [CGKeyCode] = [122, 120, 99, 118, 96, 97, 98, 100, 101, 109, 103, 111]
        for (i, code) in fkeys.enumerated() { t[0x3A + i] = code }
        let rest: [Int: CGKeyCode] = [
            0x28: 36,   // return
            0x29: 53,   // escape
            0x2A: 51,   // delete (backspace)
            0x2B: 48,   // tab
            0x2C: 49,   // space
            0x2D: 27,   // -
            0x2E: 24,   // =
            0x2F: 33,   // [
            0x30: 30,   // ]
            0x31: 42,   // backslash
            0x33: 41,   // ;
            0x34: 39,   // '
            0x35: 50,   // `
            0x36: 43,   // ,
            0x37: 47,   // .
            0x38: 44,   // /
            0x39: 57,   // caps lock
            0x4A: 115,  // home
            0x4B: 116,  // page up
            0x4C: 117,  // forward delete
            0x4D: 119,  // end
            0x4E: 121,  // page down
            0x4F: 124,  // right
            0x50: 123,  // left
            0x51: 125,  // down
            0x52: 126,  // up
            0xE0: 59,   // left control
            0xE1: 56,   // left shift
            0xE2: 58,   // left option
            0xE3: 55,   // left command
            0xE4: 62,   // right control
            0xE5: 60,   // right shift
            0xE6: 61,   // right option
            0xE7: 54,   // right command
        ]
        t.merge(rest) { _, new in new }
        return t
    }()
}
