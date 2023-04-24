//
//  NextomeSettingsUI.swift
//  iosApp
//
//  Created by Anna Labellarte on 25/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation


struct NextomeSettingsUI{
    var scanPeriod: String? = nil
    var scanPeriodDefault: String = ""
    
    var betweenScanPeriod: String? = nil
    var betweenScanPeriodDefault: String = ""
    
    var beaconListMaxSize: String? = nil
    var beaconListMaxSizeDefault: String = ""
    
    var rssiThreshold: String? = nil
    var rssiThresholdDefault: String = ""
    
    var eventTimeout: String? = nil
    var eventTimeoutDefault: String = ""
    
    var localizationMethod: String? = nil
    var localizationMethodDefault: String = ""
    
    var isParticleActive: String? = nil
    var isParticleActiveDefault: String = ""

    var isSendPositionToServerEnabled: String? = nil
    var isSendPositionToServerEnabledDefault: String = ""
   
    var isSendAssetsToServerEnabled: String? = nil
    var isSendAssetsToServerEnabledDefault: String = ""

    var hasBeenEdited = false
    var isEditable = true
    var isDebugModeEnabled = false
}
