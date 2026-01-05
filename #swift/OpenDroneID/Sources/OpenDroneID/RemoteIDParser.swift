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
}
