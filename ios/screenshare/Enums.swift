//
//  Enums.swift
//  ScreenShare
//
//  Created by TechIncu on 14/10/2021.
//

import Foundation

public enum BroadcastOptions: Int, Codable {
    case screenShareWithAppAudio
    case screenShareWithMicAudio
    case videoCall
    case screenShareWithAppAudioAndVideoCall
    case screenShareWithVideoCall
}
