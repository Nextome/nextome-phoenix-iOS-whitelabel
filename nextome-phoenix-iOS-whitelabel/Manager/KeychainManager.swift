//
//  KeyChainManager.swift
//  iosApp
//
//  Created by Anna Labellarte on 09/11/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainManager{
    var keychain = KeychainSwift()
    
    func save<T: Codable>(key: String, value: T) throws{
        let data = try JSONEncoder().encode(value)
        keychain.set(data, forKey: key)
    }
    
    func getData<T>(forKey key: String, ofType type: T.Type) throws -> T? where T: Codable{
        guard let data = keychain.getData(key) else {
            return nil
        }
    
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
    
    func clearData(forKey key: String){
        keychain.delete(key)
    }
}
