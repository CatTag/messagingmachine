
import Cocoa

@IBDesignable class MessageInputField: NSControl, NSTextFieldDelegate {
    @IBOutlet var contentView: NSView?
    @IBOutlet var textField: AutoGrowingTextField!
    @IBOutlet var delegate: NSObject?
    @IBOutlet var emojiButton: NSButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        var topLevelObjects : NSArray?
        if Bundle.main.loadNibNamed("MessageInputField", owner: self, topLevelObjects: &topLevelObjects) {
            contentView = topLevelObjects!.first(where: { $0 is NSView }) as? NSView
            self.addSubview(contentView!)
            contentView?.frame = self.bounds
            
            textField.focusRingType = .none
            textField.delegate = self
        }
    }

    @IBAction func emojiButtonClicked(_ sender: NSButton) {
        textField.selectText(self)
        
        let lengthOfInput = NSString(string: textField.stringValue).length
        textField.currentEditor()?.selectedRange = NSMakeRange(lengthOfInput, 0)
        
        NSApplication.shared.orderFrontCharacterPalette(nil)
    }
}
