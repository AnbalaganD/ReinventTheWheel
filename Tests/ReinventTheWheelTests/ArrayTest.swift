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
    var array = UnsafeArray<Int>()
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
func collectionHasSameElement(rawArray: [Int]) async throws {
    var array = UnsafeArray<Int>()
    rawArray.forEach { array.append($0) }
    
    let result = rawArray == array
    print(result)
}

@Test
func dropLast() {
    let array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5)
    let item = array.dropLast()
    print(item)
    array.forEach { print($0) }
}

@Test
func arrayCount() {
    let array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
    #expect(array.count == 6)
}

@Test
func removedLastElement() {
    var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
    array.remove(at: array.count - 1)
    array.remove(at: array.count - 1)
    
    #expect([1, 2, 3, 4] == array)
}

@Test
func removedFirstElement() {
    var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
    array.remove(at: 0)
    array.remove(at: 0)
    
    #expect([3, 4, 5, 6] == array)
}

@Test
func removeMiddleElement() {
    var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
    array.remove(at: 3)
    array.remove(at: 2)

    #expect([1, 2, 5, 6] == array)
}

@Test
func removeAll() {
    var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
    array.removeAll()

    #expect([] == array)
}

@Test
func valueSemantics() async throws {
    let firstArray: UnsafeArray<Int> = [1, 2, 3, 4, 5, 6]
    var secondArray = firstArray
    
    secondArray.remove(at: 1)
    #expect(firstArray.count == 6)
    print(firstArray)
    print(secondArray)
}

@Test
func insertFirst() async throws {
    var array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
    array.insert(at: 0, value: 6)
    #expect(array == [6, 1, 2, 3, 4, 5])
}

@Test
func insertLast() async throws {
    var array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
    array.insert(at: array.count, value: 6)
    #expect(array == [1, 2, 3, 4, 5, 6])
}

@Test
func insertMiddle() async throws {
    var array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
    array.insert(at: 3, value: 6)
    #expect(array == [1, 2, 3, 6, 4, 5])
}
