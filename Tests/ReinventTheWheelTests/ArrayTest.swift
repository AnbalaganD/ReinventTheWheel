//
//  ArrayTest.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

import Testing
@testable import ReinventTheWheel

@Test
func ensureAllArrayOperationWork() async throws {
    let array = UnsafeArray<Int>()
    array.append(1)
    array.append(2)
    array.append(3)
    array.append(4)
    array.append(5)
    array.append(6)
    
    array.remove(at: array.count - 1)
    
    for element in array.enumerated() {
        print(element.offset, element.element)
    }
}

@Test(arguments: [Array<Int>.init(arrayLiteral: 1, 2, 3, 4, 5)])
func checkCollectionHasSameElement(rawArray: [Int]) async throws {
    let array = UnsafeArray<Int>()
    rawArray.forEach { array.append($0) }
    
    let result = rawArray == array
    print(result)
}
