//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    private let currencyInCirculation : [String : Double] = ["USD" : 1,
                                                             "GBP" : 0.5,
                                                             "EUR" : 1.5,
                                                             "CAN" : 1.25]
    public func convert(_ to: String) -> Money {
        let result : Int = Int((Double(self.amount) / currencyInCirculation[self.currency]!) * Double(currencyInCirculation[to]!))
        return Money(amount: result, currency: to)
    }
  
    public func add(_ to: Money) -> Money {
        return Money(amount: Int(convert(to.currency).amount + to.amount), currency: to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        return Money(amount: Int(convert(from.currency).amount - from.amount), currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType

    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
  
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
  
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case JobType.Salary(let number):
            return number
        case JobType.Hourly(let number):
            return Int(number * Double(hours))
        }
    }
  
    open func raise(_ amt : Double) {
        switch self.type {
        case JobType.Salary(let number):
            self.type = JobType.Salary(number + Int(amt))
        case JobType.Hourly(let number):
            self.type = JobType.Hourly(number + amt)
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0

    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return self._job
        }
        set(value) {
            if self.age > 18 {
                self._job = value
            }
        }
    }
  
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return self._spouse
        }
        set(value) {
            if self.age > 18 {
                self._spouse = value
            }
        }
    }
  
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
  
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self._job?.type)) spouse:\(String(describing: self._spouse))]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
  
    public init(spouse1: Person, spouse2: Person) {
        if spouse1._spouse == nil && spouse2._spouse == nil {
            spouse1._spouse = spouse2
            spouse2._spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
  
    open func haveChild(_ child: Person) -> Bool {
        if members[0].age < 21 && members[1].age < 21 {
            return false
        }
        members.append(child)
        return true
    }
  
    open func householdIncome() -> Int {
        var result : Int = 0
        for familyMember in members {
            if familyMember._job != nil {
                result += familyMember._job!.calculateIncome(2000)
            }
        }
        return result
    }
}
