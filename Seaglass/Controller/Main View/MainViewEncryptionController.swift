

import Cocoa

class MainViewEncryptionController: NSViewController {

    @IBOutlet weak var EnableEncryptionCheckbox: NSButton!
    @IBOutlet weak var PreventUnverifiedCheckbox: NSButton!
    @IBOutlet weak var ConfirmButton: NSButton!
    @IBOutlet weak var ConfirmSpinner: NSProgressIndicator!
    
    var roomId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfirmButton.isEnabled = false
        ConfirmButton.alphaValue = 1
        ConfirmSpinner.alphaValue = 0
        
        if let room = MatrixServices.inst.session.room(withRoomId: roomId) {
            EnableEncryptionCheckbox.state = room.state.isEncrypted ? .on : .off
            EnableEncryptionCheckbox.isEnabled = EnableEncryptionCheckbox.state == .off
        } else {
            EnableEncryptionCheckbox.isEnabled = false
        }
        
        PreventUnverifiedCheckbox.state = MatrixServices.inst.session.crypto.warnOnUnknowDevices ? .on : .off
    }
    
    
    @IBAction func allowUnverifiedCheckboxChanged(_ sender: NSButton) {
        guard sender == PreventUnverifiedCheckbox else { return }
        
        MatrixServices.inst.session.crypto.warnOnUnknowDevices = PreventUnverifiedCheckbox.state == .on
        UserDefaults.standard.set(MatrixServices.inst.session.crypto.warnOnUnknowDevices, forKey: "CryptoParanoid")
    }
    
    @IBAction func enableEncryptionCheckboxChanged(_ sender: NSButton) {
        guard sender == EnableEncryptionCheckbox else { return }
        
        ConfirmButton.isEnabled =
            EnableEncryptionCheckbox.isEnabled &&
            EnableEncryptionCheckbox.state == .on
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: NSButton) {
        guard sender == ConfirmButton else { return }
        guard EnableEncryptionCheckbox.isEnabled else { return }
        guard roomId != "" else { return }
        
        ConfirmButton.isEnabled = false
        ConfirmSpinner.startAnimation(self)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            ConfirmButton.animator().alphaValue = 0
            ConfirmSpinner.animator().alphaValue = 1
        }, completionHandler: {
            if let room = MatrixServices.inst.session.room(withRoomId: self.roomId) {
                room.enableEncryption(withAlgorithm: "m.megolm.v1.aes-sha2") { (response) in
                    if response.isSuccess {
                        self.dismiss(self)
                        return
                    }
                    
                    print("Failed to enable encryption: \(response.error!.localizedDescription)")
                    self.dismiss(self)
                }
            }
        })
    }
}
