
import Cocoa

class UserSettingsProfileController: UserSettingsTabController {
    
    @IBOutlet weak var showMostRecentMessageButton: NSButton!
    @IBOutlet weak var showRoomTopicButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeToSize = NSSize(width: 450, height: 75)
    }
    
    @IBAction func sidebarPreferenceChanged(_ sender: NSButton) {
        // the buttons need to be set to the same action so they act as a group
    }

}
