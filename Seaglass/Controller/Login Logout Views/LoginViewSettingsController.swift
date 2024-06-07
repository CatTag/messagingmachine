

import Cocoa

class LoginViewSettingsController: NSViewController {

    @IBOutlet var HomeserverURLField: NSTextField!
    @IBOutlet var DisableCacheCheckbox: NSButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.string(forKey: "Homeserver") != nil {
            HomeserverURLField.stringValue = defaults.string(forKey: "Homeserver")!
        }
        
        if defaults.bool(forKey: "DisableCache") {
            DisableCacheCheckbox.state = .on
        }
    }
    
    override func viewWillDisappear() {
        homeserverURLFieldEdited(sender: HomeserverURLField)
    }
    
    @IBAction func homeserverURLFieldEdited(sender: NSTextField) {
        if URL(string: HomeserverURLField.stringValue) == nil {
            defaults.setValue("https://matrix.org", forKey: "Homeserver")
        } else {
            defaults.setValue(HomeserverURLField.stringValue, forKey: "Homeserver")
        }
	}
    
    @IBAction func disableCacheCheckboxEdited(sender: NSButton) {
        defaults.setValue(DisableCacheCheckbox.state == .on, forKey: "DisableCache")
    }
}
