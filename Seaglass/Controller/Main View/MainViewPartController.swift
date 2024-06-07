

import Cocoa

class MainViewPartController: NSViewController {
    @IBOutlet weak var LeaveButton: NSButton!
    @IBOutlet weak var LeaveSpinner: NSProgressIndicator!
    
    var roomId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LeaveButton.isEnabled = MatrixServices.inst.session.room(withRoomId: roomId) != nil
    }
    
    @IBAction func leaveButtonClicked(_ sender: NSButton) {
        if roomId == "" {
            return
        }
        
        LeaveButton.isEnabled = false
        LeaveSpinner.startAnimation(sender)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            LeaveButton.animator().alphaValue = 0
            LeaveSpinner.animator().alphaValue = 1
        }, completionHandler: {
            MatrixServices.inst.session.leaveRoom(self.roomId) { (response) in
                if response.isFailure, let error = response.error {
                    let alert = NSAlert()
                    alert.messageText = "Failed to leave room \(self.roomId)"
                    alert.informativeText = error.localizedDescription
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
                sender.window?.contentViewController?.dismiss(sender)
            }
        })
    }
}
