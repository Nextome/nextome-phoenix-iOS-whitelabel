//
//  SettingsViewModel.swift
//  iosApp
//
//  Created by Anna Labellarte on 18/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
import Resolver
import NextomeLocalization

class SettingsViewModel{
    private var settingsRepository: SettingsRepository = SettingsRepositoryImpl()
    private lazy var appSettings = settingsRepository.getSettings()
    var type: SettingsViewController.SettingsType = .LOGIN
   
    var settingsUI: NextomeSettingsUI{
        NextomeSettingsUI.initFrom(appSettings: appSettings, andType: type)
    }
    
    func initViewModel(withType type: SettingsViewController.SettingsType){
        self.type = type
    }
    
    func restoreData(){
        appSettings = NextomeAppSettings()
        settingsRepository.updateSettings(settings: appSettings)
    }
    
    func save(uiData: NextomeSettingsUI){
        let settings = uiData.asNextomeAppSettings()
        settingsRepository.updateSettings(settings: settings)
    }
    
    
}




