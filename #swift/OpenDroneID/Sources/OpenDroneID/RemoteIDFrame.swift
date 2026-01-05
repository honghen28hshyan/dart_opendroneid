import Foundation

public struct RemoteIDFrame: Sendable, Equatable {
    public static let byteCount = 25
    public static let payloadCount = 24

    public let header: RemoteIDHeader
    public let payload: Data
    public let message: AnyRemoteIDMessage

    public var protocolVersion: UInt8 { header.protocolVersion }
    public var messageType: MessageType { header.messageType }

    public init(data: Data) throws {
        guard data.count == Self.byteCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: Self.byteCount, actual: data.count)
        }
        let headerByte = data[data.startIndex]
        self.header = try RemoteIDHeader(byte: headerByte)
        self.payload = data.subdata(in: (data.startIndex + 1)..<(data.startIndex + Self.byteCount))
        self.message = try AnyRemoteIDMessage.make(type: header.messageType, payload: payload)
    }
}

/// 类型擦除：让调用者在不知道具体消息类型时也能统一处理。
public struct AnyRemoteIDMessage: Sendable, Equatable {
    public let type: MessageType
    public let payload: Data
    public let decoded: Decoded?

    public enum Decoded: Sendable, Equatable {
        case basicID(BasicIDMessage)
        case location(LocationMessage)
        case authentication(AuthenticationMessage)
        case selfID(SelfIDMessage)
        case system(SystemMessage)
        case operatorID(OperatorIDMessage)
        case raw
    }

    public static func make(type: MessageType, payload: Data) throws -> AnyRemoteIDMessage {
        // 先确保 payload 长度符合 Remote ID 常规
        guard payload.count == RemoteIDFrame.payloadCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.payloadCount, actual: payload.count)
        }

        switch type {
        case .basicID:
            let m = try BasicIDMessage(payload: payload)
            return .init(type: type, payload: payload, decoded: .basicID(m))
        case .location:
            let m = try LocationMessage(payload: payload)
            return .init(type: type, payload: payload, decoded: .location(m))
        case .authentication:
            let m = try AuthenticationMessage(payload: payload)
            return .init(type: type, payload: payload, decoded: .authentication(m))
        case .selfID:
            let m = try SelfIDMessage(payload: payload)
            return .init(type: type, payload: payload, decoded: .selfID(m))
        case .system:
            let m = try SystemMessage(payload: payload)
            return .init(type: type, payload: payload, decoded: .system(m))
        case .operatorID:
            let m = try OperatorIDMessage(payload: payload)
            return .init(type: type, payload: payload, decoded: .operatorID(m))
        case .messagePack:
            // messagePack 具体需要按更高层封装处理；先原样保留
            return .init(type: type, payload: payload, decoded: .raw)
        }
    }
}
