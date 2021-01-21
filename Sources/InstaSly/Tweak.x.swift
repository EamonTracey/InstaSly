import UIKit
import Orion
import InstaSlyC

typealias IS = InstaSly

struct InstaSly: Tweak {
    
    static var prefs: NSDictionary? { NSDictionary(contentsOfFile: "/var/mobile/Library/Preferences/com.eamontracey.instaslypreferences.plist") }
    
    // Preferences
    static var enabled: Bool = true
    static var confirmDoubleTap: Bool = true
    static var confirmHeartTap: Bool = false
    static var confirmFollow: Bool = true
    static var alertStyle: UIAlertController.Style = .alert
    
    // Initializer
    init() {
        loadPreferences(nil, nil, nil, nil, nil)
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, loadPreferences, "com.eamontracey.instaslypreferences/update" as CFString, nil, .coalesce)
    }
    
}

class IGFeedSectionControllerHook: ClassHook<IGFeedSectionController> {

    var username: String { target.media.user.username }
    var hasLiked: Bool { target.media.hasLiked }
    
    func feedItemPhotoCellDidDoubleTapToLike(_ cell: Any, locationInfo: Any) {
        if IS.confirmDoubleTap && !hasLiked {
            confirmExecution("Like \(username)'s photo?") {
                self.orig.feedItemPhotoCellDidDoubleTapToLike(cell, locationInfo: locationInfo)
            }
        } else {
            orig.feedItemPhotoCellDidDoubleTapToLike(cell, locationInfo: locationInfo)
        }
    }
    
    func videoCellDidDoubleTap(_ cell: Any) {
        if IS.confirmDoubleTap && !hasLiked {
            confirmExecution("Like \(username)'s video?") {
                self.orig.videoCellDidDoubleTap(cell)
            }
        } else {
            orig.videoCellDidDoubleTap(cell)
        }
    }
    
    func feedItemPageCellDidDoubleTapToLike(_ cell: Any) {
        if IS.confirmDoubleTap && !hasLiked {
            confirmExecution("Like \(username)'s post?") {
                self.orig.feedItemPageCellDidDoubleTapToLike(cell)
            }
        } else {
            orig.feedItemPageCellDidDoubleTapToLike(cell)
        }
    }
    
    func feedItemActionCellDidTapLikeButton(_ cell: Any) {
        if IS.confirmHeartTap && !hasLiked {
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
    let alert = UIAlertController(title: title, message: nil, preferredStyle: IS.alertStyle)
    let yesAction = UIAlertAction(title: "Yes", style: .default) {_ in executionClosure()}
    let noAction = UIAlertAction(title: "No", style: .destructive)
    alert.addAction(yesAction)
    alert.addAction(noAction)
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: .none)
}
