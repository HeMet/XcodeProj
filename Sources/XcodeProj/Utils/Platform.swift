struct Platform {
    #if os(Windows)
    static let lineTerminator = "\r\n"
    #else
    static let lineTerminator = "\n"
    #endif
}