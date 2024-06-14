//
//  NextomeSettingsUI+Extensions.swift
//  iosApp
//
//  Created by Anna Labellarte on 25/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
import NextomeLocalization

extension NextomeSettingsUI{
    func asNextomeAppSettings() -> NextomeAppSettings{
        return NextomeAppSettings(
            scanPeriod: scanPeriod.asInt64(),
            betweenScanPeriod: betweenScanPeriod.asInt64(),
            beaconListMaxSize: beaconListMaxSize.asInt32(),
            rssiThreshold: rssiThreshold.asInt(),
            eventTimeout: eventTimeout.asInt64(),
            localizationMethod: nil,
            isParticleActive: nil,
            isSendPositionToServerEnabled: isSendPositionToServerEnabled.asBoolFromYesOrNo(),
            isSendAssetsToServerEnabled: isSendAssetsToServerEnabled.asBoolFromYesOrNo(),
            isDebugModeEnabled: isDebugModeEnabled
        )
        
    }
    
    static func initFrom(appSettings: NextomeAppSettings,andType type: SettingsViewController.SettingsType) -> NextomeSettingsUI{
        var venueSettings: NextomeSettings? = nil
        var isFromMap = false
        if case .MAP(let settings) = type {
            venueSettings = settings
            isFromMap = true
        }
        let venueScanPeriod = venueSettings?.scanPeriod
        let venueBetweenScanPeriod = venueSettings?.betweenScanPeriod
        let venueBeaconListMaxSize = venueSettings?.beaconListMaxSize
        let venueRssiTrashold = venueSettings?.rssiThreshold
        let venueEventTimeout = venueSettings?.eventsTimeout
        let venueSendAssetsToServer = venueSettings?.sendAssetsToServer
        let venueSendPositions = venueSettings?.sendPositionsToServer
        
        return NextomeSettingsUI(
            scanPeriod: appSettings.scanPeriod.toString() ?? venueScanPeriod.toString(),
            scanPeriodDefault: venueScanPeriod.toString() ?? L10n.settingsDefault,
            betweenScanPeriod: appSettings.betweenScanPeriod.toString() ?? venueBetweenScanPeriod.toString(),
            betweenScanPeriodDefault: venueBetweenScanPeriod.toString() ?? L10n.settingsDefault,
            beaconListMaxSize: appSettings.beaconListMaxSize.toString() ?? venueBeaconListMaxSize.toString(),
            beaconListMaxSizeDefault: venueBeaconListMaxSize.toString() ?? L10n.settingsDefault,
            rssiThreshold: appSettings.rssiThreshold.toString() ?? venueRssiTrashold.toString(),
            rssiThresholdDefault: venueRssiTrashold.toString() ?? L10n.settingsDefault,
            eventTimeout: appSettings.eventTimeout.toString() ?? venueEventTimeout.toString(),
            eventTimeoutDefault: venueEventTimeout.toString() ?? L10n.settingsDefault,
            localizationMethod: nil,
            isParticleActive: nil,
            isSendPositionToServerEnabled: appSettings.isSendPositionToServerEnabled.toYesOrNoString() ?? venueSendPositions.toYesOrNoString(),
            isSendPositionToServerEnabledDefault:
                venueSendPositions.toYesOrNoString() ?? L10n.settingsDefault,
            isSendAssetsToServerEnabled: appSettings.isSendAssetsToServerEnabled.toYesOrNoString() ?? venueSendAssetsToServer.toYesOrNoString(),
            isSendAssetsToServerEnabledDefault:
                venueSendAssetsToServer.toYesOrNoString() ?? L10n.settingsDefault,
            hasBeenEdited: appSettings.hasBeenEdited() ,
            isEditable: !isFromMap,
            isDebugModeEnabled: appSettings.isDebugModeEnabled
        )
    }
}
