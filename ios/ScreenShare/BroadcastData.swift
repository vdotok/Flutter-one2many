import UIKit
import iOSSDKStreaming
struct BroadcastData:Codable {
    var broadcastType: BroadcastType
    var broadcastOptions: BroadcastOptions
    var broadcastGroupID: String?

}
struct ScreenShareAudioState: Codable {
    let screenShareAudio: ScreenShareBytes
}
struct ScreenShareScreenState: Codable {
    let screenShareScreen: ScreenShareBytes
}
