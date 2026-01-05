import Foundation

public protocol RemoteIDMessage: Sendable {
    static var type: MessageType { get }
    init(payload: Data) throws
    var payload: Data { get }
}

public struct RawRemoteIDMessage: RemoteIDMessage, Equatable {
    public static let type: MessageType = .messagePack // 仅占位，不用于匹配
    public let messageType: MessageType
    public let payload: Data

    public init(messageType: MessageType, payload: Data) {
        self.messageType = messageType
        self.payload = payload
    }

    public init(payload: Data) throws {
        throw OpenDroneIDError.unsupportedMessageFormat("Use init(messageType:payload:) for RawRemoteIDMessage")
    }
}
