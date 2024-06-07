

import Foundation

final class AppDefaults {
    
    static let shared = AppDefaults()
    
    struct Key {
        static let showMostRecentMessageInSidebar = "showMostRecentMessageInSidebar"
    }
    
    @discardableResult init() {
        let defaults: [String: Any] = [
            Key.showMostRecentMessageInSidebar: true
        ]
        
        UserDefaults.standard.register(defaults: defaults)
    }
    
    var showMostRecentMessageInSidebar: Bool {
        get {
            return bool(for: Key.showMostRecentMessageInSidebar)
        }
        set {
            setBool(for: Key.showMostRecentMessageInSidebar, newValue)
        }
    }
}

private extension AppDefaults {
    
    func bool(for key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func setBool(for key: String, _ flag: Bool) {
        UserDefaults.standard.set(flag, forKey: key)
    }

}
