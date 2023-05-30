import ReplayKit
import iOSSDKStreaming
import MMWormhole
class SampleHandler: RPBroadcastSampleHandler {
    var vtokSdk : VideoTalkSDK?
    var request: RegisterRequest?
    var audioState: ScreenShareAudioState!
    var screenState: ScreenShareScreenState!
    let wormhole = MMWormhole(applicationGroupIdentifier: AppsGroup.APP_GROUP, optionalDirectory: "wormhole")
    var baseSession : VTokBaseSession?
    var screenShareData: ScreenShareAppData?
    override init() {
        super.init()
        audioState = ScreenShareAudioState(screenShareAudio: .passAll)
        screenState = ScreenShareScreenState(screenShareScreen: .passAll)
        wormhole.listenForMessage(withIdentifier: "InitScreenSharingSdk", listener: { [weak self] (messageObject) -> Void in
            guard let self = self else {return }
            if let message = messageObject as? String {
               print(message)
                self.getScreenShareAppData(with: message)
            
            }
        })
        wormhole.listenForMessage(withIdentifier: "updateAudioState", listener: { [weak self] (messageObject) -> Void in
            guard let self = self else {return }
            if let message = messageObject as? String {
               print(message)
                self.setScreenShareAppAudio(with: message)
            }
        })
        wormhole.listenForMessage(withIdentifier: "updateScreenState", listener: { [weak self] (messageObject) -> Void in
            guard let self = self else {return }
            if let message = messageObject as? String {
               print(message)
                guard let sdk = self.vtokSdk,
                      let session = self.screenShareData
                else { return }
                self.setScreenShareScreen(with: message)
                sdk.disableScreen(for: session.baseSession, state: self.screenState.screenShareScreen)
            }
        })
    }
    func setScreenShareAppAudio(with message: String) {
        guard let data = message.data(using: .utf8) else {return }
        audioState = try! JSONDecoder().decode(ScreenShareAudioState.self, from: data)
    }
    func setScreenShareScreen(with message: String) {
        guard let data = message.data(using: .utf8) else {return }
        screenState = try! JSONDecoder().decode(ScreenShareScreenState.self, from: data)
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func getScreenShareAppData(with message: String) {
        let completeData = convertToDictionary(text: message)
        let projectID : String = completeData!["projectID"] as! String
        let dataWithoutProjectID = completeData!["jsonWithoutProjectID"] as! String
        guard let data = dataWithoutProjectID.data(using: .utf8) else {return }
        screenShareData = try? JSONDecoder().decode(ScreenShareAppData.self, from: data)
        guard screenShareData != nil else { return }
        initSdk(projectID: projectID)
    }
    func initSdk(projectID : String){
        guard let screenShareData = screenShareData else {return }
        request = RegisterRequest(type: "request",
                                      requestType: "register",
                                      referenceId: screenShareData.baseSession.from,
                                      authorizationToken: screenShareData.authenticationToken,
                                      socketType: .screenShare,
                                      requestId: getRequestId(),
                                      projectId: projectID)
        vtokSdk = VTokSDK(url: screenShareData.url, registerRequest: request!, connectionDelegate: self, connectionType: .screenShare)
    }
    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        let meeeeeeee : NSString =  "StartScreenSharing"
        wormhole.passMessageObject(meeeeeeee, identifier: "Command")
    }
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
//        let message: String = "sessionTerminated"
        guard let vtokSdk = vtokSdk, let session = screenShareData?.baseSession else {return}
//        let jsonData = try! JSONEncoder().encode(session)
//        let jsonString = String(data: jsonData, encoding: .utf8)! as NSString
//        wormhole.passMessageObject(jsonString, identifier: message)
        let VTokBaseSessionDictionary : [String : String] = [
         "state": "SessionTerminated"
     ]
     let jsonData1 = try! JSONEncoder().encode(VTokBaseSessionDictionary)
     let message1 = String(data: jsonData1, encoding: .utf8)!
        print(message1)
     wormhole.passMessageObject(message1 as NSCoding, identifier: "sessionUpdates")
//    wormhole.passMessageObject(message1 as NSCoding, identifier: "updateScreenState")
        vtokSdk.hangup(session: session)
     
    }
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case .video:
            switch screenState.screenShareScreen {
            case .none:
                break
            case .passAll:
                vtokSdk?.processSampleBuffer(sampleBuffer, with: sampleBufferType)
            }
        case .audioApp,.audioMic:
            switch audioState.screenShareAudio {
            case .passAll:
                vtokSdk?.processSampleBuffer(sampleBuffer, with: sampleBufferType)
            case .none:
                break
            }
        @unknown default:
            break
        }
    }
}
extension SampleHandler: SDKConnectionDelegate {
    func didGenerate(output: SDKOutPut) {
        switch output {
        case .registered:
            print("==== screeen share registerd ====")
            guard let sdk = vtokSdk, let session = screenShareData else {return}
            self.screenShareData = session
            sdk.initiate(session: session.baseSession, sessionDelegate: self)
         //   sdk.initiate(session: <#T##VTokBaseSession#>, sessionDelegate: <#T##SessionDelegate?#>)
        case .disconnected(_):
            print("==== screeen failed to registerd ====")
            break
        case .sessionRequest(_):
            break
        }
    }
}
extension SampleHandler: SessionDelegate {
    func configureLocalViewFor(session: VTokBaseSession, with stream: [UserStream]) {
    }
    func configureRemoteViews(for session: VTokBaseSession, with streams: [UserStream]) {
    }
    func sessionTimeDidUpdate(with value: String) {
    }
    func stateDidUpdate(for session: VTokBaseSession) {
//        let data = ScreenShareAppData(url: " ",
//                                      authenticationToken: "",
//                                      : session)
        
        print("this is lsjdljs", session.state)
        
        switch session.state {
        case .calling:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "Calling",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .ringing:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "Ringing",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .connected:
            do {
//                let message: NSString = "onParticipantAdd"
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "onParticipantAdd",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .failed:
            break
        case .rejected:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "Rejected",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .onhold:
            break
        case .busy:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "Busy",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .missedCall:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "MissedCall",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .receivedSessionInitiation:
            break
        case .invalidTarget:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "InValidTarget",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .hangup:
            do {                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "HungUp",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .tryingToConnect:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "TryingConnect",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
//        case .reconnect:
//            do {
//                let VTokBaseSessionDictionary : [String : String] = [
//                    "from": session.from,
//                    "requestID": session.requestID,
//                    "sessionUUID": session.sessionUUID,
//                    "state": "Reconnecting",
//        //            "associatedSessionUUID": session.?associatedSessionUUID ,
//                    "connectedUsers": String(session.connectedUsers.count),
//                    "sessionTime": session.sessionTime
//                ]
//                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
//                let message = String(data: jsonData, encoding: .utf8)!
//                   print(message)
//                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
//                }
//            break
        case .updateParticipent:
            do {
                let VTokBaseSessionDictionary : [String : String] = [
                    "from": session.from,
                    "requestID": session.requestId,
                    "sessionUUID": session.sessionUuid,
                    "state": "UpdateParticipent",
        //            "associatedSessionUUID": session.?associatedSessionUUID ,
                    "connectedUsers": String(session.connectedUsers.count),
                    "sessionTime": session.sessionTime
                ]
                let jsonData = try! JSONEncoder().encode(VTokBaseSessionDictionary)
                let message = String(data: jsonData, encoding: .utf8)!
                   print(message)
                wormhole.passMessageObject(message as NSCoding, identifier: "sessionUpdates")
                }
            break
        case .insufficientBalance:
            
                print("hello")
            
            break
        case .suspendedByProvider:
            print("bye")
            break
        default: break
            
        }
    }
    func didGetPublicUrl(for session: VTokBaseSession, with url: String) {
        let message : NSString =  url as NSString
//        print(message)
        wormhole.passMessageObject(message, identifier: "didGetPublicURL")
    }
}
extension SampleHandler {
    func getRequestId() -> String {
        let generatable = IdGenerator()
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = Date(timeIntervalSince1970: TimeInterval(myTimeInterval)).stringValue()
        let tenantId = "12345"
        let requestId = self.request?.referenceId ?? ""
        let token = generatable.getUUID(string: time + tenantId + requestId)
        return token
    }
}
