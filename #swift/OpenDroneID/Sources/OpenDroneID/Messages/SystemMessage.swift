import Foundation

public struct SystemMessage: RemoteIDMessage, Equatable {
    public static let type: MessageType = .system
    public let payload: Data

    public let flags: UInt8
    public let raw: Data

    public init(payload: Data) throws {
        guard payload.count == RemoteIDFrame.payloadCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.payloadCount, actual: payload.count)
        }
        self.payload = payload

        var r = ByteReader(payload)
        self.flags = try r.readByte()
        self.raw = try r.readBytes(RemoteIDFrame.payloadCount - 1)
    }
}
