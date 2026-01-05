import Foundation

public struct SelfIDMessage: RemoteIDMessage, Equatable {
    public static let type: MessageType = .selfID
    public let payload: Data

    public let descriptionType: UInt8
    public let descriptionData: Data

    public init(payload: Data) throws {
        guard payload.count == RemoteIDFrame.payloadCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.payloadCount, actual: payload.count)
        }
        self.payload = payload

        var r = ByteReader(payload)
        self.descriptionType = try r.readByte()
        self.descriptionData = try r.readBytes(RemoteIDFrame.payloadCount - 1)
    }

    public var descriptionStringLossy: String {
        // 常见为 ASCII/UTF-8；失败则 hex
        String(data: descriptionData, encoding: .utf8) ?? descriptionData.map { String(format: "%02x", $0) }.joined()
    }
}
