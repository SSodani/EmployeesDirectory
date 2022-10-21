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
    
    func getSmallImage(completion: @escaping (UIImage) -> ()) {
        self.getImage(url:employeeData?.photo_url_small ?? "",imageType: "small") { image in
            completion(image)
        }
    }
    
    func getLargeImage(completion: @escaping (UIImage) -> ()) {
        self.getImage(url:employeeData?.photo_url_large ?? "",imageType: "large") { image in
            completion(image)
        }
    }
    
    
    func call() {
        print("call \(self.employeeData?.full_name ?? "") @ \(self.employeeData?.phone_number ?? " ") ")
    }
    
    func email() {
        print("email \(self.employeeData?.full_name ?? "") @ \(self.employeeData?.email_address ?? " ") ")
    }
    
    
    //check image in the cache and if not available then load from the URL
    func getImage(url:String,imageType:String,completion: @escaping (UIImage) -> ())  {
        
        guard let employeeData = self.employeeData else {
            completion(UIImage(named: "placeHolder-employee") ?? UIImage())
            return
            
        }
        
        guard let url = URL(string:url) else {
            completion(UIImage(named: "placeHolder-employee") ?? UIImage())
            return
        }
        
        let pathComponent = employeeData.uuid + imageType
        
        let cachedFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                pathComponent,
                isDirectory: false
            )
        
        //if cached file has the image then fetch that image
        if let data = try? Data(contentsOf: cachedFile) {
            completion(UIImage(data: data) ?? UIImage(named: "placeHolder-employee") ?? UIImage())
            return
        }
        
        //load imahe from server if not cached
        NetworkService.shared.download(url: url) { tempURL, error in
            
            guard let tempURL = tempURL else {
                completion(UIImage(named: "placeHolder-employee") ?? UIImage())
                return
            }

                        if FileManager.default.fileExists(atPath: cachedFile.path) {
                            try? FileManager.default.removeItem(at: cachedFile)
                        }
            
                            try? FileManager.default.copyItem(at: tempURL, to: cachedFile)
           
            do {
                let data = try Data(contentsOf: tempURL)
                try? FileManager.default.copyItem(at: tempURL, to: cachedFile)
                completion(UIImage(data: data) ?? UIImage(named: "placeHolder-employee") ?? UIImage())
                            return
            }catch {
                completion(UIImage(named: "placeHolder-employee") ?? UIImage())
            }
            
        }
    }
}
