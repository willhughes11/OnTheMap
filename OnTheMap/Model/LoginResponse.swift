//  LoginResponse.swift
//  OnTheMap
//
//  Created by William K Hughes on 10/18/20.
//



import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}


