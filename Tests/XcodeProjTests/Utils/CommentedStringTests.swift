import Foundation
import PathKit
import XCTest
@testable import XcodeProj

class CommentedStringTests: XCTestCase {
    func test_commentedStringEscaping() {
        let quote = "\""
        let escapedNewline = "\\n"
        let escapedWindowsNewLine = "\\r\\n"
        let escapedQuote = "\\\""
        let escapedEscape = "\\\\"
        let escapedTab = "\\t"

        let values: [String: String] = [
            "a": "a",
            "a".quoted: "\(escapedQuote)a\(escapedQuote)".quoted,
            "@": "@".quoted,
            "[": "[".quoted,
            "<": "<".quoted,
            ">": ">".quoted,
            ";": ";".quoted,
            "&": "&".quoted,
            "$": "$",
            "{": "{".quoted,
            "}": "}".quoted,
            "___NAME___": "___NAME___".quoted,
            "\\": escapedEscape.quoted,
            "//": "//".quoted,
            "+": "+".quoted,
            "-": "-".quoted,
            "=": "=".quoted,
            ",": ",".quoted,
            " ": " ".quoted,
            "\t": escapedTab.quoted,
            "a;": "a;".quoted,
            "a_a": "a_a",
            "a a": "a a".quoted,
            "": "".quoted,
            "a\(quote)q\(quote)a": "a\(escapedQuote)q\(escapedQuote)a".quoted,
            "a\(quote)q\(quote)a".quoted: "\(escapedQuote)a\(escapedQuote)q\(escapedQuote)a\(escapedQuote)".quoted,
            "a\(escapedQuote)a\(escapedQuote)": "a\(escapedEscape)\(escapedQuote)a\(escapedEscape)\(escapedQuote)".quoted,
            "a\na": "a\\na".quoted,
            "\n": escapedNewline.quoted,
            "\na": "\(escapedNewline)a".quoted,
            "a\n": "a\(escapedNewline)".quoted,
            "a\na".quoted: "\(escapedQuote)a\(escapedNewline)a\(escapedQuote)".quoted,
            "a\(escapedNewline)a": "a\(escapedEscape)na".quoted,
            "a\(escapedNewline)a".quoted: "\(escapedQuote)a\(escapedEscape)na\(escapedQuote)".quoted,
            // Windows (start)
            "a\r\na": "a\\r\\na".quoted,
            "\r\n": escapedWindowsNewLine.quoted,
            "\r\na": "\(escapedWindowsNewLine)a".quoted,
            "a\r\n": "a\(escapedWindowsNewLine)".quoted,
            "a\r\na".quoted: "\(escapedQuote)a\(escapedWindowsNewLine)a\(escapedQuote)".quoted,
            "a\(escapedWindowsNewLine)a": "a\(escapedEscape)r\(escapedEscape)na".quoted,
            "a\(escapedWindowsNewLine)a".quoted: "\(escapedQuote)a\(escapedEscape)r\(escapedEscape)na\(escapedQuote)".quoted,
            // Windows (end)
            "\"": escapedQuote.quoted,
            "\"\"": "\(escapedQuote)\(escapedQuote)".quoted,
            "".quoted.quoted: "\(escapedQuote)\(escapedQuote)\(escapedQuote)\(escapedQuote)".quoted,
            "a=\"\"": "a=\(escapedQuote)\(escapedQuote)".quoted,
            "马旭": "马旭".quoted,
        ]

        for (initial, expected) in values {
            let escapedString = CommentedString(initial).validString
            if escapedString != expected {
                XCTFail("Escaped strings are not equal:\ninitial: \(initial)\nexpect:  \(expected)\nescaped: \(escapedString) ")
            }
        }
    }
}
