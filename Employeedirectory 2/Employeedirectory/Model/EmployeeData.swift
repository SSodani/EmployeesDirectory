//
//  EmployeeData.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import Foundation

// MARK: - EMPLOYEE DATA

enum EmployeeType:String,Codable {
    case FULL_TIME
    case PART_TIME
    case CONTRACTOR
}

struct EmployeeDirectory:Codable {
    var employees:[EmployeeData]
}

struct EmployeeData:Codable {
    var uuid:String
    var full_name:String
    var phone_number:String?
    var email_address:String?
    var biography:String?
    var photo_url_small:String?
    var photo_url_large:String?
    var team:String
    var employee_type:EmployeeType
}





