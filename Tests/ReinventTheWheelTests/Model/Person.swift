//
//  Person.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 10/01/25.
//


class Person: CustomStringConvertible {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    var description: String {
        "Person(name: \(name), age: \(age))"
    }
    
    deinit {
        print("Person deinit called")
    }
}