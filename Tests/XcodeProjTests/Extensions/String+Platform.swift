@testable import XcodeProj

extension String {
    var withPlatformLineTerminator: String {
        #if os(Windows)
            return replacingOccurrences(of: "\n", with: Platform.lineTerminator)
        #else
            return self
        #endif
    }
}