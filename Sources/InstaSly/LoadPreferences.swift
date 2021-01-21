import UIKit

infix operator ?=
private func ?=<T>(lhs: inout T, rhs: Any?) {
    if let newValue = rhs as? T {
        lhs = newValue
    }
}

func loadPreferences(_ center: CFNotificationCenter?, _ sender: UnsafeMutableRawPointer?, _ name: CFNotificationName?, _ object: UnsafeRawPointer?, _ userInfo: CFDictionary?) {
    if let prefs = IS.prefs {
        IS.enabled ?= prefs["enabled"]
        IS.confirmDoubleTap ?= prefs["confirmDoubleTap"]
        IS.confirmHeartTap ?= prefs["confirmHeartTap"]
        IS.confirmFollow ?= prefs["confirmFollow"]
        IS.alertStyle ?= UIAlertController.Style(rawValue: Int((prefs["alertStyle"] as! String)) ?? 1)
    }
}
