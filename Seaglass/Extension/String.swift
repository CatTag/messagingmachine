

import AppKit
import TSMarkdownParser

extension String {
    func toAttributedStringFromMarkdown(justify: NSTextAlignment, color: NSColor) -> NSAttributedString{
        if self.count == 0 {
            return NSAttributedString()
        }
        guard let data = data(using: .utf16, allowLossyConversion: true) else { return NSAttributedString() }
        if data.isEmpty {
            return NSAttributedString()
        }
        
        let parser = TSMarkdownParser.standard()
        parser.defaultAttributes = [:]
        parser.defaultAttributes!["NSColor"] = color
        parser.defaultAttributes!["NSFont"] = NSFont.systemFont(ofSize: 12)
        parser.monospaceAttributes["NSColor"] = NSColor(calibratedRed: 0.53, green: 0.54, blue: 0.58, alpha: 1.00)
        parser.monospaceAttributes["NSFont"] = NSFont(name: "Menlo", size: NSFont.smallSystemFontSize)
        parser.quoteAttributes[0]["NSColor"] = NSColor.gray
        parser.quoteAttributes[0]["NSFont"] = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        
        let str: NSMutableAttributedString = parser.attributedString(fromMarkdown: self) as! NSMutableAttributedString
        let range = NSRange(location: 0, length: str.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = justify
        
        str.beginEditing()
        str.removeAttribute(.paragraphStyle, range: range)
        str.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        str.endEditing()
        
        return str
    }
    
    func toAttributedStringFromHTML(justify: NSTextAlignment) -> NSAttributedString{
        if self.count == 0 {
            return NSAttributedString()
        }
        guard let data = data(using: .utf16, allowLossyConversion: true) else { return NSAttributedString() }
        if data.isEmpty {
            return NSAttributedString()
        }
        do {
            
            let str: NSMutableAttributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            let range = NSRange(location: 0, length: str.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = justify
            
            str.beginEditing()
            str.removeAttribute(.paragraphStyle, range: range)
            
            str.enumerateAttributes(in: range, options: [], using: { attr, attrRange, _ in
                if let font = attr[.font] as? NSFont {
                    if font.familyName == "Times" {
                        let newFont = NSFontManager.shared.convert(font, toFamily: NSFont.systemFont(ofSize: NSFont.systemFontSize).familyName!)
                        str.addAttribute(.font, value: newFont, range: attrRange)
                    }
                }
            })
            
            str.addAttribute(.foregroundColor, value: NSColor.textColor, range: range)
            str.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            str.endEditing()
            
            return str
        } catch {
            return NSAttributedString()
        }
    }
}
