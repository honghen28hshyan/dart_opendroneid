# OpenDroneID (Swift)

本目录提供一个可用于 iOS 的 Swift Package：`OpenDroneID`。

## 集成（本地包）
1. 打开 Xcode -> File -> Add Packages...
2. 选择 “Add Local...”
3. 选中：`/workspaces/dart_opendroneid/#swift/OpenDroneID`

或在你的 `Package.swift` 里以本地路径依赖加入。

## 快速使用

```swift
import OpenDroneID

let frames = try RemoteIDParser.parseFrames(from: serviceData) // serviceData: Data
for frame in frames {
    print(frame.messageType, frame.protocolVersion)
    // frame.message: 具体消息（BasicID/Location/...) 或 raw
}
```

## 说明
- Remote ID 广播里常见的是 25 字节一帧（1 字节 header + 24 字节 payload）。
- 本实现优先保证“拆帧 + 类型识别 + 原始 payload”可靠。
- 对具体字段的数值解码（经纬度/高度/速度等）各版本/实现可能存在差异；如你希望与本仓库 Dart 实现严格一致，请把 Dart 解析对应文件加入工作集（或用 `#codebase`），我可以逐字段对齐迁移。
