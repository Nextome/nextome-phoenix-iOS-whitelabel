//
//  KotlinTypesExtensions.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 29/03/23.
//


import Foundation
import PhoenixSdk

extension Bool{
    func asKotlinBoolean() -> KotlinBoolean{
        return KotlinBoolean(bool: self)
    }
}

extension Int32{
    func asKotlinInt() -> KotlinInt{
        return KotlinInt(int: self)
    }
}

extension Int64{
    func asKotlinLong() -> KotlinLong{
        return KotlinLong(longLong: self)
    }
}

extension Int{
    func asKotlinInt() -> KotlinInt{
        return KotlinInt(int: Int32(self))
    }
}
