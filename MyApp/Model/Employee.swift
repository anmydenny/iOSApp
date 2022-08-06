//
//  Employee.swift
//  MyApp
//
//  Created by anmy on 06/08/22.
//

import Foundation

// MARK: - EmployeeDetail
struct EmployeeDetail:Codable {
    let name: String?
    let username: String
    let profileImage: String?
    let email: String
    let address: Address?
    let phone: String?
    let website: String?
    let company: CompanyDetails?

    enum CodingKeys: String, CodingKey {
            case name, username, email
            case profileImage = "profile_image"
            case address, phone, website, company
        }
}

// MARK: - Address
struct Address:Codable {
    let street : String?
    let suite: String?
    let city: String?
    let zipcode: String?
}

// MARK: - Company
struct CompanyDetails:Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}

struct Company: Codable {
    let name, catchPhrase, bs: String
}

typealias EmployeeDetails = [EmployeeDetail]

