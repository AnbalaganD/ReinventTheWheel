//
//  Person.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 10/01/25.
//


class Person: CustomStringConvertible {
    let name: String
    let age: Int
    
    private var deinitHandler: () -> Void
    
    init(name: String, age: Int, deinitHandler: @escaping () -> Void = {}) {
        self.name = name
        self.age = age
        self.deinitHandler = deinitHandler
    }
    
    var description: String {
        "Person(name: \(name), age: \(age))"
    }
    
    deinit {
        deinitHandler()
    }
}
