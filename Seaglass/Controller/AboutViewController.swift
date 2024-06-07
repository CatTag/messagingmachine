  

import Cocoa

class AboutViewController: NSViewController {
    
    @IBOutlet weak var versionTextField: NSTextField!

    @IBAction func viewSourceCodeButtonPressed(_: NSButton) {
        guard let sourceURL = URL(string: "https://github.com/neilalexander/seaglass") else { return }
        NSWorkspace.shared.open(sourceURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.view as! NSVisualEffectView).material = .menu
        (self.view as! NSVisualEffectView).isEmphasized = true
        
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

        versionTextField.stringValue = "Version " + appVersionString
    }
    
}
