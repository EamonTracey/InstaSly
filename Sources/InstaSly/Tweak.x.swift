import UIKit
import Orion
import NomaePreferences
import InstaSlyC

typealias IS = InstaSly

struct InstaSly: Tweak {
    
    static let identifier = "com.eamontracey.instasly"
    
    // Preferences
    @Preference("enabled", identifier: identifier) static var enabled = true
    @Preference("confirmDoubleTap", identifier: identifier) static var confirmDoubleTap = true
    @Preference("confirmHeartTap", identifier: identifier) static var confirmHeartTap = false
    @Preference("confirmFollow", identifier: identifier) static var confirmFollow = true
    @Preference("alertStyle", identifier: identifier) static var alertStyle = 1
    @Preference("alwaysAlert", identifier: identifier) static var alwaysAlert = true
    @Preference("minimumPostAge", identifier: identifier) static var minimumPostAge = 604800 // Time stored in seconds
    @Preference("postAgeMultiplier", identifier: identifier) static var postAgeMultiplier = 1
    
}

class IGFeedSectionControllerHook: ClassHook<IGFeedSectionController> {

    var username: String { target.media.user.username }
    var hasLiked: Bool { target.media.hasLiked }
    var postOldEnough: Bool { NSDate.now.timeIntervalSince(target.media.takenAtDate.date) > Double(IS.minimumPostAge * IS.postAgeMultiplier) }
    // Date() caused issues, so use NSDate.now
    
    func feedItemPhotoCellDidDoubleTapToLike(_ cell: Any, locationInfo: Any) {
        if IS.confirmDoubleTap && !hasLiked && (IS.alwaysAlert || postOldEnough) {
            confirmExecution("Like \(username)'s photo?") {
                self.orig.feedItemPhotoCellDidDoubleTapToLike(cell, locationInfo: locationInfo)
            }
        } else {
            orig.feedItemPhotoCellDidDoubleTapToLike(cell, locationInfo: locationInfo)
        }
    }
    
    func videoCellDidDoubleTap(_ cell: Any) {
        if IS.confirmDoubleTap && !hasLiked && (IS.alwaysAlert || postOldEnough) {
            confirmExecution("Like \(username)'s video?") {
                self.orig.videoCellDidDoubleTap(cell)
            }
        } else {
            orig.videoCellDidDoubleTap(cell)
        }
    }
    
    func feedItemPageCellDidDoubleTapToLike(_ cell: Any) {
        if IS.confirmDoubleTap && !hasLiked && (IS.alwaysAlert || postOldEnough) {
            confirmExecution("Like \(username)'s post?") {
                self.orig.feedItemPageCellDidDoubleTapToLike(cell)
            }
        } else {
            orig.feedItemPageCellDidDoubleTapToLike(cell)
        }
    }
    
    func feedItemActionCellDidTapLikeButton(_ cell: Any) {
        if IS.confirmHeartTap && !hasLiked && (IS.alwaysAlert || postOldEnough) {
            confirmExecution("Like \(username)'s post?") {
                self.orig.feedItemActionCellDidTapLikeButton(cell)
            }
        } else {
            orig.feedItemActionCellDidTapLikeButton(cell)
        }
    }
    
    static func hookWillActivate() -> Bool {
        return IS.enabled
    }
    
}

class IGFollowControllerHook: ClassHook<IGFollowController> {
    
    var username: String { target.user.username }
    var followsOrHasRequestedUser: Bool { target.followAccountButton.buttonState != 2 }
    // 2 -> Not Followed | 3 -> Followed | 4 -> Requested
    
    func _didPressFollowButton() {
        if IS.confirmFollow && !followsOrHasRequestedUser {
            confirmExecution("Follow \(username)?") {
                self.orig._didPressFollowButton()
            }
        } else {
            orig._didPressFollowButton()
        }
    }
    
    static func hookWillActivate() -> Bool {
        return IS.enabled
    }
    
}

private func confirmExecution(_ title: String?, executionClosure: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style(rawValue: IS.alertStyle) ?? .alert)
    let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in executionClosure() }
    let noAction = UIAlertAction(title: "No", style: .destructive)
    alert.addAction(yesAction)
    alert.addAction(noAction)
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: .none)
}
