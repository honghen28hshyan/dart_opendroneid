import Foundation

public struct LocationMessage: RemoteIDMessage, Equatable {
    public static let type: MessageType = .location
    public let payload: Data

    // 保守：只给出常用的“可能字段”原始值；具体比例/单位请与你的上层定义对齐后再解释。
    public let status: UInt8
    public let rawLatitudeLE: Int32
    public let rawLongitudeLE: Int32

    public init(payload: Data) throws {
        guard payload.count == RemoteIDFrame.payloadCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.payloadCount, actual: payload.count)
        }
        self.payload = payload

        var r = ByteReader(payload)
        self.status = try r.readByte()
        self.rawLatitudeLE = try r.readInt32LE()
        self.rawLongitudeLE = try r.readInt32LE()

        // 剩余字段依实现/版本不同：速度、高度、精度、航向、时间戳等。
        // 先不强行解码，调用方可直接使用 payload 自行解析。
    }

    /// 常见约定：纬度/经度 = raw * 1e-7（仅作为便捷参考，不保证与你的 Dart 版本一致）
    public var latitudeDegreesApprox: Double { Double(rawLatitudeLE) * 1e-7 }
    public var longitudeDegreesApprox: Double { Double(rawLongitudeLE) * 1e-7 }
}
