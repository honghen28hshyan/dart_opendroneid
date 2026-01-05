import XCTest
@testable import OpenDroneID

final class RemoteIDParserTests: XCTestCase {
    func testParseSingleFrame() throws {
        // header: [messageType:4][protocolVersion:4]
        // messageType=basicID(0), protocolVersion=1 => 0x01
        guard let data = Data(hex: "80000000FFFFFFFFFFFFE47A2C153401E47A2C15340100008098833B00000000A000200400185249442D313538314638374C5732353432303032334E564EDD53FA0BBC0DCEF119030112313538314638374C5732353432303032334E564E0000001116B5000000000000000000005F070000D0070000FFFF000041080000000000000000010000000000000100000000000000007856AD") else {
            return XCTFail("Failed to create Data from hex")
        }

        let frames = try RemoteIDParser.parseFrames(from: data)
        XCTAssertEqual(frames.count, 1)
        XCTAssertEqual(frames[0].protocolVersion, 1)
        XCTAssertEqual(frames[0].messageType, .basicID)

        guard case .basicID(let m)? = frames[0].message.decoded else {
            return XCTFail("Expected BasicID decoded message")
        }
        XCTAssertEqual(m.idTypeAndUaType, 0xAB)
        XCTAssertEqual(m.uasId.count, RemoteIDFrame.payloadCount - 1)
    }

    func testParseFromOUIStream_sampleHex() throws {
        // 这是“整段流”，不能直接按 25-byte 对齐 parseFrames(from:)
        let hex =
        "0x80000000FFFFFFFFFFFFE47A2C153401E47A2C15340100008098833B00000000A000200400185249442D313538314638374C5732353432303032334E564EDD53FA0BBC0DCEF119030112313538314638374C5732353432303032334E564E0000001116B5000000000000000000005F070000D0070000FFFF000041080000000000000000010000000000000100000000000000007856AD"
        let data = try Data(hexString: hex)

        XCTAssertThrowsError(try RemoteIDParser.parseFrames(from: data))

        let frames = try RemoteIDParser.parseFramesFromOUIStream(from: data, oui: (0xFA, 0x0B, 0xBC))
        XCTAssertEqual(frames.count, 3)
        XCTAssertEqual(frames[0].messageType, .basicID)
        XCTAssertEqual(frames[1].messageType, .location)
        XCTAssertEqual(frames[2].messageType, .system)

        XCTAssertEqual(frames[0].protocolVersion, 1)
        XCTAssertEqual(frames[1].protocolVersion, 1)
        XCTAssertEqual(frames[2].protocolVersion, 1)
    }

    func testRejectNonMultipleOf25() {
        let data = Data([0x10, 0x00, 0x00]) // 3 bytes
        XCTAssertThrowsError(try RemoteIDParser.parseFrames(from: data))
    }
}

private extension Data {
    init(hexString: String) throws {
        let s = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "0x", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\t", with: "")

        guard s.count % 2 == 0 else { throw OpenDroneIDError.unsupportedMessageFormat("Odd-length hex string") }

        var out = Data()
        out.reserveCapacity(s.count / 2)

        var i = s.startIndex
        while i < s.endIndex {
            let j = s.index(i, offsetBy: 2)
            let byteStr = s[i..<j]
            guard let b = UInt8(byteStr, radix: 16) else {
                throw OpenDroneIDError.unsupportedMessageFormat("Invalid hex: \(byteStr)")
            }
            out.append(b)
            i = j
        }
        self = out
    }
}
