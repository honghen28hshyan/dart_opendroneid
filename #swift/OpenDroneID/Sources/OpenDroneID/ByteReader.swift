import Foundation

public struct ByteReader: Sendable {
    private let data: Data
    private(set) var offset: Int = 0

    public init(_ data: Data) {
        self.data = data
    }

    public var remaining: Int { max(0, data.count - offset) }

    public mutating func readByte() throws -> UInt8 {
        guard offset + 1 <= data.count else { throw OpenDroneIDError.truncatedData }
        defer { offset += 1 }
        return data[offset]
    }

    public mutating func readBytes(_ count: Int) throws -> Data {
        guard offset + count <= data.count else { throw OpenDroneIDError.truncatedData }
        defer { offset += count }
        return data.subdata(in: offset..<(offset + count))
    }

    public mutating func readUInt16LE() throws -> UInt16 {
        let b = try readBytes(2)
        return UInt16(b[b.startIndex]) | (UInt16(b[b.startIndex + 1]) << 8)
    }

    public mutating func readInt16LE() throws -> Int16 {
        Int16(bitPattern: try readUInt16LE())
    }

    public mutating func readUInt32LE() throws -> UInt32 {
        let b = try readBytes(4)
        return UInt32(b[b.startIndex])
            | (UInt32(b[b.startIndex + 1]) << 8)
            | (UInt32(b[b.startIndex + 2]) << 16)
            | (UInt32(b[b.startIndex + 3]) << 24)
    }

    public mutating func readInt32LE() throws -> Int32 {
        Int32(bitPattern: try readUInt32LE())
    }
}
