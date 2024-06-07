
import Cocoa

class LoginSuccessfulSegue: NSStoryboardSegue {
    override func perform() {
        if let src = self.sourceController as? LoginViewController, let dest = self.destinationController as? MainWindowController {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.5
                src.view.window!.animator().alphaValue = 0
            }, completionHandler: {
                src.view.window!.close()
                dest.showWindow(src)
            })
        }
    }
}
