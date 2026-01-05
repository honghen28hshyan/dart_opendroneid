import Foundation

public enum MessageType: UInt8, Sendable {
    case basicID = 0x0
    case location = 0x1
    case authentication = 0x2
    case selfID = 0x3
    case system = 0x4
    case operatorID = 0x5
    case messagePack = 0xF

    public var description: String {
        switch self {
        case .basicID: return "BasicID"
        case .location: return "Location"
        case .authentication: return "Authentication"
        case .selfID: return "SelfID"
        case .system: return "System"
        case .operatorID: return "OperatorID"
        case .messagePack: return "MessagePack"
        }
    }
}

/// Remote ID 常见 header: 1 byte = [messageType:4][protocolVersion:4]
public struct RemoteIDHeader: Sendable, Equatable {
    public let protocolVersion: UInt8
    public let messageType: MessageType
    public let raw: UInt8

    public init(byte: UInt8) throws {
        self.raw = byte
        let typeNibble = (byte >> 4) & 0x0F
        self.protocolVersion = byte & 0x0F

        guard let t = MessageType(rawValue: typeNibble) else {
            throw OpenDroneIDError.unknownMessageType(typeNibble)
        }
        self.messageType = t
    }
}
