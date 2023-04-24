//
//  MapViewModel.swift
//  iosApp
//
//  Created by Anna Labellarte on 11/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
import PhoenixSdk

class MapViewModel{
    var settingsRepository: SettingsRepository = SettingsRepositoryImpl()
    
    lazy var appSettings = settingsRepository.getSettings()
    
    //Will be setted by viewController depending on the venue found
    var venueSettings: NextomeSettings? = nil
    
    var delegate: MapDelegate? = nil
    var poiList: [NextomePoi]? = nil
    
    
    func handleError(error: NextomeException){
        
        if error is NextomeException.InvalidCredentialException{
            self.delegate?.onAuthenticationError(message: error.message)
        }else if error is NextomeException.CriticalException{
            self.delegate?.showGenericError(message: error.message)
        }else if error is NextomeException.GenericException && appSettings.isDebugModeEnabled{
            self.delegate?.showGenericError(message: error.message)
        }
    }
    
    
}

protocol MapDelegate{
    func onAuthenticationError(message: String)
    func showGenericError(message: String)
}
