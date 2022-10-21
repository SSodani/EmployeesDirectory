//
//  NetworkService.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import Foundation

enum NetworkError:Error {
    case inValidURL
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}


class NetworkService {
    
    static let shared = NetworkService()
    
    //load data using the given URL string
     func loadData<T:Decodable>(of type: T.Type = T.self, url:String,completion:@escaping (Result<T,NetworkError>) -> ()) {
        
        guard let url = URL(string: url) else {
            completion(Result.failure(.inValidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...209).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
                return
            }catch(let error) {
                completion(.failure(.decodingError(error)))
                return
            }
        }.resume()
    }
    
    
    func getEmployeeData(completion: @escaping (Result<[EmployeeData], NetworkError>) -> ()) {
        self.loadData(of: EmployeeDirectory.self, url: "https://s3.amazonaws.com/sq-mobile-interview/employees.json") { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let employeeDirectory):
                completion(.success(employeeDirectory.employees))
            }
        }
    }


//download the image and store in the file manager/cache
func download(url:URL, completion:@escaping (URL?,NetworkError?) -> ()) {
    
    URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
        
        if let error = error {
            completion(nil,.transportError(error))
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, !(200...209).contains(httpResponse.statusCode) {
            completion(nil,.serverError(statusCode: httpResponse.statusCode))
            return
        }
        
        guard let tempURL = tempURL else {
            completion(nil,.noData)
            return
        }
        
        completion(tempURL,nil)
                
    }.resume()
}
}






