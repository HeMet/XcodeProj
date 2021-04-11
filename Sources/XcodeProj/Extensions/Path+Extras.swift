import Foundation
// swiftlint:disable all
import PathKit

// MARK: - Path extras.

extension Path {
    /// Creates a directory
    ///
    /// - Throws: an errof if the directory cannot be created.
    func mkpath(withIntermediateDirectories: Bool) throws {
        try FileManager.default.createDirectory(atPath: string, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
    }

    func relative(to path: Path) -> Path {
        var pathComponents = absolute().components
        var baseComponents = path.absolute().components

        #if os(Windows)
        if let pathFirst = pathComponents.first, let baseFirst = baseComponents.first {
            if pathFirst != baseFirst, pathFirst.hasSuffix(":") && baseFirst.hasSuffix(":") {
                // paths with different volumes have no common root
                return self
            }
            if (pathFirst == "/" && baseFirst.hasSuffix(":")) || (pathFirst.hasSuffix(":") && baseFirst == "/") {
                pathComponents.removeFirst()
                baseComponents.removeFirst()
            }
        }
        #endif

        var commonComponents = 0
        for (index, component) in baseComponents.enumerated() {
            if component != pathComponents[index] {
                break
            }
            commonComponents += 1
        }

        var resultComponents = Array(repeating: "..", count: baseComponents.count - commonComponents)
        resultComponents.append(contentsOf: pathComponents[commonComponents...])

        return Path(components: resultComponents)
    }
}

// swiftlint:enable all
