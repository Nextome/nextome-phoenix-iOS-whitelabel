//
//  MapViewModel.swift
//  iosApp
//
//  Created by Anna Labellarte on 11/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
import NextomeLocalization

class MapViewModel{
    var settingsRepository: SettingsRepository = SettingsRepositoryImpl()
    
    lazy var appSettings = settingsRepository.getSettings()
    
    //Will be setted by viewController depending on the venue found
    var venueSettings: NextomeSettings? = nil
    
    var delegate: MapDelegate? = nil
    var poiList: [NextomePoi]? = nil
    
    
    func handleError(error: NextomeException){
        
        if error is InvalidCredentialException{
            self.delegate?.onAuthenticationError(message: error.message)
        }else if error is CriticalException{
            self.delegate?.showGenericError(message: error.message)
        }else if error is GenericException && appSettings.isDebugModeEnabled{
            self.delegate?.showGenericError(message: error.message)
        }
    }
    
    
}

protocol MapDelegate{
    func onAuthenticationError(message: String)
    func showGenericError(message: String)
}
