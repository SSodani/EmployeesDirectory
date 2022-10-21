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

protocol EmployeeDataProtocol {
    func getEmployeeData(url:String,completion: @escaping (Result<EmployeeDirectory,NetworkError>) -> ())
}

protocol DownloadImageProtocol {
    func loadImage(url:URL, for userId:String, completion: @escaping (Result<Data,NetworkError>) -> ())
    func download(url:URL, toFile file:URL, completion:@escaping (NetworkError?) -> ())
}

class NetworkService {
    
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
}


//MARK: - EmployeeDataProtocol

extension NetworkService:EmployeeDataProtocol {
    func getEmployeeData(url:String,completion: @escaping (Result<EmployeeDirectory, NetworkError>) -> ()) {
        self.loadData(of: EmployeeDirectory.self, url: url) { Result in
            completion(Result)
        }
    }
}

//MARK: - DownloadImageProtocol

extension NetworkService:DownloadImageProtocol {
    
    //this function  process the data to get image from it and stores the image in cache
    func loadImage(url: URL, for userId: String, completion: @escaping (Result<Data,NetworkError>) -> ()) {
        
        //get the cached file for the employee based on the UUID
        let cachedFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                userId,
                isDirectory: false
            )
        
        //if cached file has the image then fetch that image
        if let data = try? Data(contentsOf: cachedFile) {
            completion(.success(data))
            return
        }
        
        //not present in the cache. Need to load the image
        self.download(url: url, toFile: cachedFile) { error in
            
            if let error = error {
                print(error)
                completion(.failure(.transportError(error)))
            }
            
            do {
                let data = try Data(contentsOf: cachedFile)
                completion(.success(data))
                return
            }
            catch(let error) {
                completion(.failure(.decodingError(error)))
            }
            
        }
    }
    
    //download the image and store in the file manager/cache
    func download(url:URL, toFile file:URL, completion:@escaping (NetworkError?) -> ()) {
        
        URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
            
            if let error = error {
                completion(.transportError(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...209).contains(httpResponse.statusCode) {
                completion(.serverError(statusCode: httpResponse.statusCode))
                return
            }
            
            guard let tempURL = tempURL else {
                completion(.noData)
                return
            }
            
            if FileManager.default.fileExists(atPath: file.path) {
                try? FileManager.default.removeItem(at: file)
            }
            
            do {
                try FileManager.default.copyItem(at: tempURL, to: file)
                completion(nil)
                
            } catch(let error) {
                completion(.decodingError(error))
                return
            }
            
        }.resume()
    }
}



