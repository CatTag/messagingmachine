
import Cocoa
import SwiftMatrixSDK

class RoomsCacheEntry: NSObject {
    var room: MXRoom
    
    @objc dynamic var roomId: String {
        return room.roomId
    }
    @objc dynamic var roomName: String {
        return room.state.name ?? ""
    }
    @objc dynamic var roomAlias: String {
        return room.state.canonicalAlias ?? ""
    }
    @objc dynamic var roomTopic: String  {
        return room.state.topic ?? ""
    }
    @objc dynamic var roomAvatar: String {
        return room.state.avatar ?? ""
    }
    @objc dynamic var roomSortWeight: Int {
        if isInvite() {
            return 0
        }
        if room.isDirect {
            return 70
        }
        if room.summary.isEncrypted || room.state.isEncrypted {
            return 60
        }
        if room.state.name == "" {
            if room.state.topic == "" {
                return 52
            }
            return 51
        }
        return 50
    }
    @objc dynamic var roomDisplayName: String {
        let count = members.count
        if roomName != "" {
            return roomName
        } else if roomAlias != "" {
            return roomAlias
        } else if count > 0 {
            var memberNames: String = ""
            for m in 0..<count {
                if members[m].userId == MatrixServices.inst.client?.credentials.userId {
                    continue
                }
                memberNames.append(members[m].displayname ?? (members[m].userId) ?? "?")
                if m < count-2 {
                    memberNames.append(", ")
                }
            }
            return memberNames
        }
        return ""
    }
    var members: [MXRoomMember] {
        return room.state.members
    }
    
    init(_ room: MXRoom) {
        self.room = room
        super.init()
    }
    
    func topic() -> String {
        return room.state.topic
    }
    
    func unread() -> Bool {
        return room.summary.localUnreadEventCount > 0
    }
    
    func highlights() -> Int {
        let highlights: Int = 0
       /* if !MatrixServices.inst.eventCache.keys.contains(self.roomId) {
            return 0
        }
        let eventCache = MatrixServices.inst.eventCache[self.roomId]!
        let filtered = eventCache.filter({
            $0.type == "m.room.message" &&
            $0.content.keys.contains("msgtype") && ($0.content["msgtype"] as! String) == "m.text" &&
            $0.content.keys.contains("body") && ($0.content["body"] as! String).contains(MatrixServices.inst.session.myUser.displayname)
        })
        highlights += filtered.count */
        return highlights
    }
    
    func encrypted() -> Bool {
        return room.summary.isEncrypted || room.state.isEncrypted
    }
    
    func isInvite() -> Bool {
        return MatrixServices.inst.session.invitedRooms().contains(where: { $0.roomId == room.roomId })
    }
}
