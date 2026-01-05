import Foundation

public struct AuthenticationMessage: RemoteIDMessage, Equatable {
    public static let type: MessageType = .authentication
    public let payload: Data

    public let authType: UInt8
    public let authData: Data

    public init(payload: Data) throws {
        guard payload.count == RemoteIDFrame.payloadCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.payloadCount, actual: payload.count)
        }
        self.payload = payload

        var r = ByteReader(payload)
        self.authType = try r.readByte()
        self.authData = try r.readBytes(RemoteIDFrame.payloadCount - 1)
    }
}
