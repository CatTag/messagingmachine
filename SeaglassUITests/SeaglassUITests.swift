

import XCTest

class SeaglassUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() {
        let defaultServer = "matrix.org"

        let loginWindowController = XCUIApplication().windows["LoginWindowController"]
        loginWindowController.staticTexts["Seaglass"].click()

        let advancedButton = loginWindowController/*@START_MENU_TOKEN@*/.buttons["LoginAdvancedButton"]/*[[".buttons[\" matrix.org\"]",".buttons[\"action\"]",".buttons[\"LoginAdvancedButton\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        advancedButton.click()

        let homeserverURLTextField = loginWindowController.popovers.textFields["https://" + defaultServer]
        homeserverURLTextField.typeKey(.delete, modifierFlags:[])
        homeserverURLTextField.typeText("\r")


        let accountNameField = loginWindowController/*@START_MENU_TOKEN@*/.textFields["AccountName"]/*[[".textFields[\"matrix.org username\"]",".textFields[\"AccountName\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //let accountPasswordField = loginWindowController.textFields["AccountPassword"]
        // doesn't find AccountPassword for unknown reason?
        accountNameField.click()
        XCTAssertEqual(accountNameField.placeholderValue, defaultServer + " username")
        //XCTAssertEqual(accountPasswordField.placeholderValue, defaultServer + " password")

        advancedButton.click()
        XCTAssertEqual(homeserverURLTextField.value as! String, "https://" + defaultServer)

        var newServer = "kde.modular.im"
        homeserverURLTextField.typeText("https://" + newServer)
        accountNameField.click()
        XCTAssertEqual(accountNameField.placeholderValue, newServer + " username")

        newServer = "not\\a\\url"
        advancedButton.click()
        homeserverURLTextField.typeText("https://" + newServer)
        accountNameField.click()
        XCTAssertEqual(accountNameField.placeholderValue, defaultServer + " username")
        advancedButton.click()
        XCTAssertEqual(homeserverURLTextField.value as! String, "https://" + defaultServer)
    }
    
}
