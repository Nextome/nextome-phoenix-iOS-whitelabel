//
//  NextomeSettings.swift
//  iosApp
//
//  Created by Anna Labellarte on 14/09/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
struct NextomeAppSettings: Codable{
    var scanPeriod: Int64? = nil
    var betweenScanPeriod: Int64? = nil
    var beaconListMaxSize: Int32? = nil
    var rssiThreshold: Int? = nil
    var eventTimeout: Int64? = nil
    var localizationMethod: String? = nil
    var isParticleActive: Bool? = nil
    var isSendPositionToServerEnabled: Bool? = nil
    var isSendAssetsToServerEnabled: Bool? = nil
    var isDebugModeEnabled: Bool = false
    
    func hasBeenEdited() -> Bool {
        return (scanPeriod != nil || betweenScanPeriod != nil ||
        beaconListMaxSize != nil || rssiThreshold != nil ||
        localizationMethod != nil || isParticleActive != nil ||
        isSendPositionToServerEnabled != nil || isSendAssetsToServerEnabled != nil ||
        eventTimeout != nil || isDebugModeEnabled)
    }
}

