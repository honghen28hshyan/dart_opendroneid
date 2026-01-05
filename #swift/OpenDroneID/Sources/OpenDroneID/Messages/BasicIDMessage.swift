import Foundation

public struct BasicIDMessage: RemoteIDMessage, Equatable {
    public static let type: MessageType = .basicID
    public let payload: Data

    /// 通常包含：ID Type / UA Type / UAS ID (ASCII/UTF8/二进制) 等。
    /// 由于不同实现/版本字段映射可能不同，这里先提供原始字节访问。
    public let idTypeAndUaType: UInt8
    public let uasId: Data

    public init(payload: Data) throws {
        guard payload.count == RemoteIDFrame.payloadCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.payloadCount, actual: payload.count)
        }
        self.payload = payload

        var r = ByteReader(payload)
        self.idTypeAndUaType = try r.readByte()
        self.uasId = try r.readBytes(RemoteIDFrame.payloadCount - 1)
    }

    public var uasIdStringLossy: String {
        String(data: uasId, encoding: .utf8) ?? uasId.map { String(format: "%02x", $0) }.joined()
    }
}
