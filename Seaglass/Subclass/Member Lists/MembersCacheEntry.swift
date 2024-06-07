

import Cocoa
import SwiftMatrixSDK

class MembersCacheEntry: NSObject {
    var member: MXRoomMember
    
    @objc dynamic var displayName: String
    @objc dynamic var userId: String
    
    init(_ member: MXRoomMember) {
        self.member = member
        
        userId = member.userId
        displayName = member.displayname ?? ""
        
        super.init()
    }
    
    func name() -> String {
        guard displayName != "" else { return userId }
        return displayName
    }
}
