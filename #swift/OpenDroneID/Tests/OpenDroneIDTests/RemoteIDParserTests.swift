import XCTest
@testable import OpenDroneID

final class RemoteIDParserTests: XCTestCase {
    func testParseSingleFrame() throws {
        // header: protocolVersion=1, messageType=basicID(0)
        let header: UInt8 = (1 << 4) | 0x0
        var bytes = [UInt8](repeating: 0, count: RemoteIDFrame.byteCount)
        bytes[0] = header
        bytes[1] = 0xAB // basicID first payload byte
        let data = Data(bytes)

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

    func testRejectNonMultipleOf25() {
        let data = Data([0x10, 0x00, 0x00]) // 3 bytes
        XCTAssertThrowsError(try RemoteIDParser.parseFrames(from: data))
    }
}
