//
//  OptionalExtensions.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 29/03/23.
//


import Foundation
extension Optional where Wrapped == Int32 {
    func toString()-> String?{
        if let raw = self{
           return String(raw)

        }else{
            return nil
        }
    }
}


extension Optional where Wrapped == Int {
    func toString()-> String?{
        if let raw = self{
           return String(raw)

        }else{
            return nil
        }
    }
}


extension Optional where Wrapped == Int64 {
    func toString()-> String?{
        if let raw = self{
           return String(raw)

        }else{
            return nil
        }
    }
}

extension Optional where Wrapped == Bool {
    func toString()-> String?{
        if let raw = self{
           return String(raw)

        }else{
            return nil
        }
    }
}


extension Optional where Wrapped == Bool {
    func toYesOrNoString()-> String?{
        if let raw = self{
            return raw ? L10n.genericYes : L10n.genericNo

        }else{
            return nil
        }
    }
}


extension Optional where Wrapped == String {
    func asInt()-> Int?{
        if let raw = self{
            return Int(raw)
        }else{
            return nil
        }
    }
    
    func asInt32()-> Int32?{
        if let raw = self{
            return Int32(raw)
        }else{
            return nil
        }
    }
    
    func asInt64()-> Int64?{
        if let raw = self{
            return Int64(raw)
        }else{
            return nil
        }
    }
    
    func asBoolFromYesOrNo() -> Bool?{
        if let raw = self, (raw == L10n.genericYes || raw == L10n.genericNo) {
            return (raw == L10n.genericYes) ? true : false
        }else{
            return nil
        }
    }
}
