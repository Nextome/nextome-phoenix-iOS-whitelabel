
import Foundation
import NextomeLocalization

class NextomeLocalizationSdkUtils{
    static func getSdkBuilder(fromSettings settings: NextomeAppSettings, clientId: String, clientSecret: String) -> NextomeLocalizationSdk.Builder{
        
        let credentials = ClientSecretCredentials(clientId: clientId, clientSecret: clientSecret)
        let builder = NextomeLocalizationSdk.Builder(baseUrl: nil, sdkCredentials: credentials, canDebug: false)
        
        if let scanPeriod = settings.scanPeriod{
            builder.setScanPeriod(millis: scanPeriod)
        }
        
        if let betweenScanPeriod = settings.betweenScanPeriod{
            builder.setBetweenScanPeriod(millis: betweenScanPeriod)
        }
        
        if let rssi = settings.rssiThreshold{
            builder.setRssiThreshold(db: Int32(rssi))
        }
        
        if let eventTimeout = settings.eventTimeout{
            builder.setEventTimeoutDuration(millis: eventTimeout)
        }
        
        if let isSendPositionEnabled = settings.isSendPositionToServerEnabled{
            builder.setSendPositionToServer(sendValues: isSendPositionEnabled)
        }
        
        
        if let isSendAssetsEnabled = settings.isSendAssetsToServerEnabled{
            builder.setSendAssetsToServer(sendValues: isSendAssetsEnabled)
        }
        return builder
        
    }
}
