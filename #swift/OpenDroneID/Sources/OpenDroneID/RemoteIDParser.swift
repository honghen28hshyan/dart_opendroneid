import Foundation

public enum RemoteIDParser {
    /// 将输入数据按 25 bytes 一帧切分并解析。
    /// - Note: 若末尾不足 25 bytes，会抛错（避免静默丢数据）。
    public static func parseFrames(from data: Data) throws -> [RemoteIDFrame] {
        guard data.count % RemoteIDFrame.byteCount == 0 else {
            throw OpenDroneIDError.invalidFrameLength(
                expected: ((data.count / RemoteIDFrame.byteCount) + 1) * RemoteIDFrame.byteCount,
                actual: data.count
            )
        }

        var frames: [RemoteIDFrame] = []
        frames.reserveCapacity(data.count / RemoteIDFrame.byteCount)

        var i = 0
        while i < data.count {
            let chunk = data.subdata(in: i..<(i + RemoteIDFrame.byteCount))
            frames.append(try RemoteIDFrame(data: chunk))
            i += RemoteIDFrame.byteCount
        }
        return frames
    }

    /// 从“包含其它字段的整段数据”中扫描 OUI(FA0BBC)，并按 OUI 封装头提取出 N 个 frame。
    /// 封装头格式（紧跟 OUI 三字节之后）：
    /// [OUI Type:1][Counter:1][TypeVersion:1][PacketLength:1][PacketCount:1][Packets...]
    /// 其中 PacketLength 常见为 0x19 (=25)。
    public static func parseFramesFromOUIStream(
        from data: Data,
        oui: (UInt8, UInt8, UInt8) = (0xFA, 0x0B, 0xBC)
    ) throws -> [RemoteIDFrame] {
        let pattern = [oui.0, oui.1, oui.2]

        func findOUIStart(_ data: Data) -> Int? {
            guard data.count >= 3 else { return nil }
            if data.count == 3 {
                return Array(data) == pattern ? 0 : nil
            }
            for i in 0...(data.count - 3) {
                if data[i] == pattern[0], data[i + 1] == pattern[1], data[i + 2] == pattern[2] {
                    return i
                }
            }
            return nil
        }

        guard let ouiIndex = findOUIStart(data) else {
            throw OpenDroneIDError.unsupportedMessageFormat("OUI FA0BBC not found")
        }

        let headerStart = ouiIndex + 3
        let headerLen = 5
        guard data.count >= headerStart + headerLen else { throw OpenDroneIDError.truncatedData }

        // 读取 OUI 封装头
        let packetLength = Int(data[headerStart + 3])
        let packetCount = Int(data[headerStart + 4])

        guard packetLength > 0, packetCount > 0 else {
            throw OpenDroneIDError.unsupportedMessageFormat("Invalid packetLength/packetCount in OUI envelope")
        }
        guard packetLength == RemoteIDFrame.byteCount else {
            throw OpenDroneIDError.invalidFrameLength(expected: RemoteIDFrame.byteCount, actual: packetLength)
        }

        let packetsStart = headerStart + headerLen
        let totalPacketsBytes = packetLength * packetCount
        guard data.count >= packetsStart + totalPacketsBytes else { throw OpenDroneIDError.truncatedData }

        var frames: [RemoteIDFrame] = []
        frames.reserveCapacity(packetCount)

        var i = packetsStart
        for _ in 0..<packetCount {
            let chunk = data.subdata(in: i..<(i + packetLength))
            frames.append(try RemoteIDFrame(data: chunk))
            i += packetLength
        }
        return frames
    }
}
