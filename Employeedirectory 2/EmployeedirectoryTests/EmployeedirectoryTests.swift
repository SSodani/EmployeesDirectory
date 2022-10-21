//
//  EmployeedirectoryTests.swift
//  EmployeedirectoryTests
//
//  Created by Sonam Sodani on 2022-10-06.
//

import XCTest
@testable import Employeedirectory

class EmployeedirectoryTests: XCTestCase {
    var sut: EmployeeViewModel!
    
    let employee1 = EmployeeData.init(uuid: "0d8fcc12-4d0c-425c-8355-390b312b909c", full_name: "Justine Mason", phone_number: nil, email_address: nil, biography: nil, photo_url_small: nil, photo_url_large: nil, team: "Point of Sale", employee_type: .FULL_TIME)
    
    
    let employee2 = EmployeeData.init(uuid: "a98f8a2e-c975-4ba3-8b35-01f719e7de2d", full_name: "Camille Rogers", phone_number: nil, email_address: nil, biography: nil, photo_url_small: nil, photo_url_large: nil, team: "Public Web & Marketing", employee_type: .PART_TIME)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = EmployeeViewModel(withProtocol: NetworkService())
        sut.employees = [employee1, employee2]
    }
    
    func testSortingByName() {
        
        sut.sortEmployeesByName()
        XCTAssertEqual(sut.employees?.first?.full_name, "Camille Rogers", "Sorting by name giving correct order")
    }
    
    func testSortingByTeam() {
        sut.sortEmployeesByTeam()
        XCTAssertEqual(sut.employees?.first?.team, "Point of Sale", "Sorting by team giving correct order")
    }
    
    func testDataForCellDisplay() {
        sut.sortEmployeesByTeam()
        
        let indexPath0 = IndexPath(row: 0, section: 0)
        let employeeTVCellViewModel0 = sut.getEmployeeData(at:indexPath0)
        
        XCTAssertEqual(employeeTVCellViewModel0?.name(), "Justine Mason", "Giving correct name as list is sorted by team")
        
        let indexPath1 = IndexPath(row: 1, section: 0)
        let employeeTVCellViewModel1 = sut.getEmployeeData(at:indexPath1)
        
        XCTAssertEqual(employeeTVCellViewModel1?.team(), "Public Web & Marketing", "Giving correct team as list is sorted by team")
        
        employeeTVCellViewModel1?.getImage(completion: { image in
            XCTAssertEqual(image, UIImage(named: "placeHolder-employee"), "Place holder as no photo url present")
        })
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
