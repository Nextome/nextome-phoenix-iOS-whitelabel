//
//  SettingsRepository.swift
//  iosApp
//
//  Created by Anna Labellarte on 18/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
protocol SettingsRepository{
    
    func getSettings() -> NextomeAppSettings
    
    func updateSettings(settings: NextomeAppSettings)
}
