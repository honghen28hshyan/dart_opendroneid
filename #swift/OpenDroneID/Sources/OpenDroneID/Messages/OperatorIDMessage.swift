import Foundation

public struct OperatorIDMessage: RemoteIDMessage, Equatable {
    public static let type: MessageType = .operatorID
    public let payload: Data

    public let operatorIdType: UInt8
    public let operatorIdData: Data

    public init(payload: Data) throws {
        guard payload.count == RemoteIDFrame.payloadCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.payloadCount, actual: payload.count)
        }
        self.payload = payload

        var r = ByteReader(payload)
        self.operatorIdType = try r.readByte()
        self.operatorIdData = try r.readBytes(RemoteIDFrame.payloadCount - 1)
    }

    public var operatorIdStringLossy: String {
        String(data: operatorIdData, encoding: .utf8) ?? operatorIdData.map { String(format: "%02x", $0) }.joined()
    }
}
