import AEXML
import Foundation

extension AEXMLDocument {
    var xmlXcodeFormat: String {
        var xml = "<?xml version=\"\(options.documentHeader.version)\" encoding=\"\(options.documentHeader.encoding.uppercased())\"?>\(Platform.lineTerminator)"
        xml += root._xmlXcodeFormat + Platform.lineTerminator
        return xml
    }
}

let attributesOrder: [String: [String]] = [
    "BuildAction": [
        "parallelizeBuildables",
        "buildImplicitDependencies",
        "runPostActionsOnFailure",
    ],
    "BuildActionEntry": [
        "buildForTesting",
        "buildForRunning",
        "buildForProfiling",
        "buildForArchiving",
        "buildForAnalyzing",
    ],
    "BuildableReference": [
        "BuildableIdentifier",
        "BlueprintIdentifier",
        "BuildableName",
        "BlueprintName",
        "ReferencedContainer",
    ],
    "TestAction": [
        "buildConfiguration",
        "selectedDebuggerIdentifier",
        "selectedLauncherIdentifier",
        "language",
        "region",
        "codeCoverageEnabled",
        "onlyGenerateCoverageForSpecifiedTargets",
        "shouldUseLaunchSchemeArgsEnv",
    ],
    "LaunchAction": [
        "buildConfiguration",
        "selectedDebuggerIdentifier",
        "selectedLauncherIdentifier",
        "language",
        "region",
        "launchStyle",
        "useCustomWorkingDirectory",
        "ignoresPersistentStateOnLaunch",
        "debugDocumentVersioning",
        "debugServiceExtension",
        "enableGPUFrameCaptureMode",
        "enableGPUValidationMode",
        "allowLocationSimulation",
        "storeKitConfigurationFileReference",
    ],
    "ProfileAction": [
        "buildConfiguration",
        "shouldUseLaunchSchemeArgsEnv",
        "savedToolIdentifier",
        "useCustomWorkingDirectory",
        "ignoresPersistentStateOnLaunch",
        "debugDocumentVersioning",
        "enableTestabilityWhenProfilingTests",
    ],
    "ActionContent": [
        "title",
        "scriptText",
        "message",
        "conveyanceType",
    ],
    "EnvironmentVariable": [
        "key",
        "value",
        "isEnabled",
    ],
    "TestableReference": [
        "skipped",
        "parallelizable",
        "testExecutionOrdering",
    ],
    "BreakpointContent": [
        "shouldBeEnabled",
        "ignoreCount",
        "continueAfterRunningActions",
        "breakpointStackSelectionBehavior",
        "scope",
        "stopOnStyle",
        "symbolName",
        "moduleName",
    ],
]

extension AEXMLElement {
    fileprivate var _xmlXcodeFormat: String {
        var xml = String()

        // open element
        xml += indent(withDepth: parentsCount - 1)
        xml += "<\(name)"

        func print(key: String, value: String) {
            xml += Platform.lineTerminator
            xml += indent(withDepth: parentsCount)
            xml += "\(key) = \"\(value.xmlEscaped)\""
        }

        if !attributes.isEmpty {
            // insert known attributes in the specified order.
            var attributes = self.attributes
            for key in attributesOrder[name] ?? [] {
                if let value = attributes.removeValue(forKey: key) {
                    print(key: key, value: value)
                }
            }

            // Print any remaining attributes.
            for (key, value) in attributes.sorted(by: { $0.key < $1.key }) {
                print(key: key, value: value)
            }
        }

        if value == nil, children.isEmpty {
            // close element
            xml += ">\(Platform.lineTerminator)"
        } else {
            if !children.isEmpty {
                // add children
                xml += ">\(Platform.lineTerminator)"
                for child in children {
                    xml += "\(child._xmlXcodeFormat)\(Platform.lineTerminator)"
                }
            } else {
                // insert string value and close element
                xml += ">\(Platform.lineTerminator)"
                xml += indent(withDepth: parentsCount - 1)
                xml += ">\(Platform.lineTerminator)\(string.xmlEscaped)"
            }
        }

        xml += indent(withDepth: parentsCount - 1)
        xml += "</\(name)>"

        return xml
    }

    private var parentsCount: Int {
        var count = 0
        var element = self

        while let parent = element.parent {
            count += 1
            element = parent
        }

        return count
    }

    private func indent(withDepth depth: Int) -> String {
        var count = depth
        var indent = String()

        while count > 0 {
            indent += "   "
            count -= 1
        }

        return indent
    }
}
