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
    
    private var employeeDataService:EmployeeDataProtocol?
    
    private var employeeDirectory:EmployeeDirectory? {
        didSet {
            self.reloadData?()
        }
    }
    
    var employees:[EmployeeData]?
    
    var reloadData : (() -> Void)?
    
    
    init(withProtocol employeeDataService:EmployeeDataProtocol = NetworkService()) {
        self.employeeDataService = employeeDataService
    }
    
    
    //MARK: - FETCHING AND HANDELING DATA
    
    //fetch employee details
    func fetchEmployeeData(url:String) {
        self.employeeDataService?.getEmployeeData(url:url, completion: {[weak self] result  in
            switch result {
            case .failure(let networkError):
                print(networkError)
            case .success(let employees):
                self?.employeeDirectory = employees
                self?.employees = self?.employeeDirectory?.employees
            }
        })
    }
    
    
    func sortEmployeesByName() {
        self.employees =  self.employees?.sorted {
                $0.full_name < $1.full_name
            }
    }
    
    func sortEmployeesByTeam() {
        self.employees =  self.employees?.sorted {
                $0.team < $1.team
            }
    }
    
    //returns array of employee details
    func getEmployees() -> [EmployeeData]? {
        return self.employees
    }
    
    
    //return an employee details view model for cell to populate the EmployeeTableViewCell
    func getEmployeeData(at indexPath:IndexPath) -> EmployeeTVCellViewModel? {
        if(self.employees?.count ?? 0 > indexPath.row) {
        let employeeData = self.employees![indexPath.row]
            return (EmployeeTVCellViewModel(employeeData: employeeData))
        }
        return nil
    }
}
