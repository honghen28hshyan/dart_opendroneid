import Foundation

public enum OpenDroneIDError: Error, Sendable, Equatable {
    case invalidFrameLength(expected: Int, actual: Int)
    case truncatedData
    case unknownMessageType(UInt8)
    case unsupportedMessageFormat(String)
}
