//
//  EmployeeViewModel.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import Foundation
import UIKit

class EmployeeViewModel {
    
    //MARK: - VARIABLES AND INITIALIZATION
    
    private var employeeDataArray:[EmployeeData]?
    
    init(with employeesData:[EmployeeData]) {
        employeeDataArray = employeesData
    }
    
    
    //MARK: - FETCHING AND HANDELING DATA
    
    func sortEmployeesByName() {
        self.employeeDataArray =  self.employeeDataArray?.sorted {
                $0.full_name < $1.full_name
            }
    }
    
    func sortEmployeesByTeam() {
        self.employeeDataArray =  self.employeeDataArray?.sorted {
                $0.team < $1.team
            }
    }
    
    //returns array of employee details
    func getEmployees() -> [EmployeeData]? {
        return self.employeeDataArray
    }
}


extension EmployeeViewModel {
    
    //return an employee details view model for cell to populate the EmployeeTableViewCell
    func getEmployeeData(at indexPath:IndexPath) -> EmployeeTVCellViewModel? {
        
        guard let employeeData = self.employeeDataArray?[indexPath.row] else { return nil}
        
            return (EmployeeTVCellViewModel(employeeData: employeeData))
    }
}
