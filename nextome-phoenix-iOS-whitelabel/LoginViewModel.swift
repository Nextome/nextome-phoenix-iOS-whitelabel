//
//  LoginViewModel.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 29/03/23.
//

import Foundation
import Resolver
class LoginViewModel{
    var settingsRepository: SettingsRepository = SettingsRepositoryImpl()
    
    lazy var settings: NextomeAppSettings = settingsRepository.getSettings()
    
    func updateSettings(){
        settings = settingsRepository.getSettings()
    }
    
}

