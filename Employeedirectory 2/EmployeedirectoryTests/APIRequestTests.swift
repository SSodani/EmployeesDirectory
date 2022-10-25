//
//  APIRequestTests.swift
//  EmployeedirectoryTests
//
//  Created by Sonam Sodani on 2022-10-21.
//

import XCTest
@testable import Employeedirectory

class APIRequestTests: XCTestCase {

    var sut = NetworkService.shared
    
    var employeeViewModel:EmployeeViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }
    
    func testValidApiCallGetsEmployeeData() throws {
        
        let promise = expectation(description:"")
        sut.getEmployeeData(url: "https://s3.amazonaws.com/sq-mobile-interview/employees.json") { [weak self] result in
            switch result {
            case .failure(let error):
                XCTFail("error = \(error.localizedDescription)")
            case .success(let employeesData):
                self?.employeeViewModel = EmployeeViewModel(with: employeesData)
            XCTAssert((employeesData as Any) is [EmployeeData] && (employeesData.count >= 0))
            promise.fulfill()
            }
        }
        self.wait(for: [promise], timeout: 5)
    }
    
    func testEmptyApiCallGetsEmptyArray() throws {
        
        let promise = expectation(description:"")
        sut.getEmployeeData(url: "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json") { result in
            switch result {
            case .failure(let error):
                XCTFail("error = \(error.localizedDescription)")
            case .success(let employeesData):
            XCTAssert(employeesData.count == 0)
            promise.fulfill()
            }
        }
        self.wait(for: [promise], timeout: 5)
    }
    
    func testMalformedAPICallThrowsError() throws {
        let promise = expectation(description:"")
        sut.getEmployeeData(url: "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json") { result in
            switch result {
            case .failure(let error):
                XCTAssert((error as Any) is NetworkError)
                promise.fulfill()
            case .success(_):
                XCTFail("malformed api returning success")
            }
        }
        self.wait(for: [promise], timeout: 5)
    }
    
    func testImageLoadCall() throws {
        
        let promise = expectation(description:"")
        let index = IndexPath.init(row: 0, section: 0)
        
        sut.getEmployeeData(url: "https://s3.amazonaws.com/sq-mobile-interview/employees.json") { [weak self] result in
            
            switch result {
                
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let employeesData):
                self?.employeeViewModel = EmployeeViewModel(with: employeesData)
                
                let employeeTVCellViewModel = self?.employeeViewModel?.getEmployeeData(at: index)
                employeeTVCellViewModel?.getSmallImage(completion: { image in
                    XCTAssert(image != UIImage(named:"placeHolder-employee"))
                    promise.fulfill()
                })
            }
    }
        self.wait(for: [promise], timeout: 5)
    }
    
    //TODO: Should make these test independent
    func testCachingWheImageisLoaded() throws {
        
        let index = IndexPath.init(row: 0, section: 0)
        let employeeTVCellViewModel = self.employeeViewModel?.getEmployeeData(at: index)
       
        
        employeeTVCellViewModel?.getSmallImage(completion: { image in
            
            let pathComponent = employeeTVCellViewModel?.employeeData?.uuid ?? "" + "small"
            
            let cachedFile = FileManager.default.temporaryDirectory
                .appendingPathComponent(
                    pathComponent,
                    isDirectory: false
                )
             let data = try? Data(contentsOf: cachedFile)
            if(data != nil) {
                XCTAssert(data != nil)
               // promise.fulfill()
            }else {
                XCTFail("image is not cached")
            }
        })
    }
    
    //TODO: Should make these test independent
    func testCachingWheImageisNotLoaded() throws {
    
        let index = IndexPath.init(row: 1, section: 0)
        let employeeTVCellViewModel = self.employeeViewModel?.getEmployeeData(at: index)
        let pathComponent = employeeTVCellViewModel?.employeeData?.uuid ?? "" + "small"
        
        let cachedFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                pathComponent,
                isDirectory: false
            )
         let data = try? Data(contentsOf: cachedFile)
        if(data != nil) {
            XCTFail("image should not be cached")
            XCTAssert(data != nil)
           // promise.fulfill()
        }else {
            XCTAssert(data == nil)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
