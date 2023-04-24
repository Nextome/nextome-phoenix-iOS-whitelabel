
import Foundation
import PhoenixSdk

class PhoenixSdkUtils{
    static func getPhoenixSdkBuilder(fromSettings settings: NextomeAppSettings, clientId: String, clientSecret: String) -> NextomePhoenixSdk.Builder{
        
        let builder = NextomePhoenixSdk.Builder(clientId: clientId, clientSecret: clientSecret)
        
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
