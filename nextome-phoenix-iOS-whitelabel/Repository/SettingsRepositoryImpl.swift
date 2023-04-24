//
//  SettingsRepository.swift
//  iosApp
//
//  Created by Anna Labellarte on 18/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
class SettingsRepositoryImpl: SettingsRepository{
    
    func getSettings() -> NextomeAppSettings{
        guard let data = UserDefaults.standard.data(forKey: "settings") else{
           return NextomeAppSettings()
        }
        let result = try? JSONDecoder().decode(NextomeAppSettings.self, from: data)
        return result ?? NextomeAppSettings()
    }
    
    func updateSettings(settings: NextomeAppSettings){
        if let data = try? JSONEncoder().encode(settings){
            UserDefaults.standard.setValue(data, forKey: "settings")
        }
    }
    
}
