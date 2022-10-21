//
//  EmployeeTVCellViewModel.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import Foundation
import UIKit

struct EmployeeTVCellViewModel {
    var employeeData:EmployeeData?
    private let imageDataService:DownloadImageProtocol = NetworkService()
}

extension EmployeeTVCellViewModel {
    
    //get name of the employee
    func name() -> String {
        return self.employeeData?.full_name ?? ""
    }
    
    //get team of the employee
    func team() -> String {
        return self.employeeData?.team ?? ""
    }
    
    //check image in the cache and if not available then load from the URL
    func getImage(completion: @escaping (UIImage) -> ())  {
        
        guard let employeeData = self.employeeData else {
            completion(UIImage(named: "placeHolder-employee") ?? UIImage())
            return
            
        }
        guard let photoURL = employeeData.photo_url_small else {
            completion(UIImage(named: "placeHolder-employee") ?? UIImage())
            return
            
        }
        guard let url = URL(string:photoURL) else {
            completion(UIImage(named: "placeHolder-employee") ?? UIImage())
            return
            
        }
    
        self.imageDataService.loadImage(url: url, for: employeeData.uuid) { result in
            switch result {
            case .success(let data) :
                
                completion(UIImage(data: data) ?? UIImage(named: "placeHolder-employee") ?? UIImage())
                return
            
            case .failure:
                completion(UIImage(named: "placeHolder-employee") ?? UIImage())
                return
            }
        }
    }
}
