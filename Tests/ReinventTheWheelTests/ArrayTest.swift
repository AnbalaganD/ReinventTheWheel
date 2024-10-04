//
//  ArrayTest.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

import Testing
@testable import ReinventTheWheel

@Test func ensureAllArrayOperationWork() async throws {
    var array = UnsafeArray<Int>()
    array.append(1)
    array.append(2)
    array.append(3)
    array.append(4)
    array.append(5)
    array.append(6)
    
    array.remove(at: array.count - 1)
    
    for element in array {
        print(element)
    }
}
