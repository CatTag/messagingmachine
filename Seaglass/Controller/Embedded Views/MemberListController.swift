
import Cocoa
import SwiftMatrixSDK

class MemberListController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet var membersCacheController: NSArrayController!
    
    @IBOutlet var MemberSearch: NSSearchField!
    
    public var roomId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if roomId == "" {
            return
        }
        
        for member in MatrixServices.inst.session.room(withRoomId: roomId).state.members {
            membersCacheController.insert(MembersCacheEntry(member), atArrangedObjectIndex: 0)
        }
        
        let membercount = (membersCacheController.arrangedObjects as! [MXRoomMember]).count
        
        MemberSearch.placeholderString = "Search \(membercount) member"
        if membercount != 1 {
            MemberSearch.placeholderString?.append(contentsOf: "s")
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if roomId == "" {
            return 0
        }
        return (membersCacheController.arrangedObjects as! [MXRoomMember]).count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let room = MatrixServices.inst.session.room(withRoomId: roomId)
        let member: MembersCacheEntry = (membersCacheController.arrangedObjects as! [MembersCacheEntry])[row]
        var powerlevel = 0
        if room?.state.powerLevels != nil {
            powerlevel = room?.state.powerLevels.powerLevelOfUser(withUserID: member.userId) ?? 0
        }
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MemberListEntry"), owner: self) as? MemberListEntry
 
        cell?.MemberName.stringValue = member.name()
        cell?.MemberDescription.stringValue = "Power level \(powerlevel)"
        cell?.MemberIcon.setAvatar(forUserId: member.userId)
        
        cell?.identifier = nil
        return cell
    }
}
