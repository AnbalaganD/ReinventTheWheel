//
//  ArrayTest.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

import Testing
@testable import ReinventTheWheel

struct ArrayTest {
    @Test(arguments: [Array<Int>(arrayLiteral: 1, 2, 3, 4, 5)])
    func collectionHasSameElement(rawArray: [Int]) async throws {
        var array = UnsafeArray<Int>()
        rawArray.forEach { array.append($0) }
        #expect(rawArray == array)
    }
    
    @Test
    func dropLast() {
        let array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5)
        let item = array.dropLast()
        #expect([1, 2, 3, 4] == item)
    }
    
    @Test
    func arrayCount() {
        let array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
        #expect(array.count == 6)
    }
    
    @Test
    func appendNewElement() {
        var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5)
        array.append(6)
        #expect(array.count == 6)
        #expect(array == [1, 2, 3, 4, 5, 6])
    }
    
    @Test
    func appendCollection() {
        var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5)
        array.append(contentsOf: [6, 7, 8, 9, 10])
        #expect(array.count == 10)
        #expect(array == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    }
    
    @Test
    func appendEmptyCollection() {
        var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5)
        array.append(contentsOf: [])
        #expect(array.count == 5)
        #expect(array == [1, 2, 3, 4, 5])
    }
    
    @Test
    func insertFirst() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
        array.insert(6, at: 0)
        #expect(array == [6, 1, 2, 3, 4, 5])
    }
    
    @Test
    func insertLast() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
        array.insert(6, at: array.count)
        #expect(array == [1, 2, 3, 4, 5, 6])
    }
    
    @Test
    func insertMiddle() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
        array.insert(6, at: 3)
        #expect(array == [1, 2, 3, 6, 4, 5])
    }
    
    @Test
    func insertCollection() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3]
        array.insert(contentsOf: [4, 5, 6], at: 0)
        #expect(array == [4, 5, 6, 1, 2, 3])
    }
    
    @Test
    func insertEmptyCollection() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3]
        array.insert(contentsOf: [], at: 0)
        #expect(array == [1, 2, 3])
    }
    
    @Test
    func replaceCollectionWithCollection() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3]
        array.replace([1], with: [5, 6, 7])
        #expect(array == [5, 6, 7, 2, 3])
    }
    
    @Test
    func replaceCollectionWithEmptyCollection() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3]
        array.replace([1, 2], with: [])
        #expect(array == [3])
    }
    
    @Test
    func replaceNonMatchCollectionWithEmptyCollection() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3]
        array.replace([4], with: [])
        #expect(array == [1, 2, 3])
    }
    
    @Test
    func replaceSubrangeCollection() {
        var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
        array.replaceSubrange(0 ..< 3, with: [8, 9, 10, 11])
        
        #expect([8, 9, 10, 11, 4, 5, 6] == array)
    }
    
    @Test
    func replaceZeroLenghtRangeIntoOtherCollection() {
        var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
        array.replaceSubrange(0 ..< 0, with: [8, 9, 10, 11])
        
        #expect([8, 9, 10, 11, 1, 2, 3, 4, 5, 6] == array)
    }
    
    @Test
    func replaceSubrangeEmptyCollection() {
        var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
        array.replaceSubrange(0 ..< 3, with: [])
        
        #expect([4, 5, 6] == array)
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
        #expect(array.capacity == 5)
    }
    
    @Test
    func removeAllKeepCapacity() {
        var array = UnsafeArray<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
        array.removeAll(keepingCapacity: true)
        #expect([] == array)
        #expect(array.capacity == 10)
    }
    
    @Test
    func valueSemantics() async throws {
        let firstArray: UnsafeArray<Int> = [1, 2, 3, 4, 5, 6]
        var secondArray = firstArray
        
        secondArray.remove(at: 1)
        #expect(firstArray.count == 6)
        #expect(secondArray.count == 5)
        #expect(firstArray == [1, 2, 3, 4, 5, 6])
        #expect(secondArray == [1, 3, 4, 5, 6])
    }
    
    @Test
    func verifyArraySlice() async throws {
        let array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
        let subArray = array[1 ..< 4]
        #expect(subArray == [2, 3, 4])
    }
    
    @Test
    func verifyReverse() async throws {
        var array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
        array.reverse()
        #expect(array == [5, 4, 3, 2, 1])
    }
    
    @Test
    func verifyReversed() async throws {
        let array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
        let reversedArray = array.reversed()
        let expectedOutPut: [Int] = [5, 4, 3, 2, 1]
        for element in reversedArray.enumerated() {
            #expect(element.element == expectedOutPut[element.offset])
        }
    }
    
    @Test
    func checkNonTrivialTypeStore() async throws {
        var array: UnsafeArray<Person> = []
        array.append(Person(name: "Anbu", age: 20))
        array.append(Person(name: "Anbalagan D", age: 21))
        array.append(Person(name: "Swift", age: 22))
        array.append(Person(name: "Tamil", age: 23))
        array.append(Person(name: "Kotlin", age: 24))
        array.append(Person(name: "Java", age: 25))
        array.append(Person(name: "Rust", age: 26))
        
        #expect(array.count == 7)
        #expect(array[0].name == "Anbu")
        #expect(array[1].name == "Anbalagan D")
        #expect(array[2].name == "Swift")
        #expect(array[3].name == "Tamil")
        #expect(array[4].name == "Kotlin")
        #expect(array[5].name == "Java")
        #expect(array[6].name == "Rust")
    }
    
    @Test
    func checkLazyIteration() async throws {
        let array: UnsafeArray<Int> = [1, 2, 3, 4, 5]
        var totalMapClouserExecute = 0
        let lazyArray = array.lazy.map {
            totalMapClouserExecute += 1
            return $0 + 10
        }
        
        for i in 0 ..< lazyArray.count - 3 {
            _ = lazyArray[i]
        }
        
        #expect(totalMapClouserExecute == 2)
    }
    
    @Test func checkDeallocation() async throws {
        var array: UnsafeArray<Person> = []
        var deinitCount = 0
        array.append(Person(name: "Anbu", age: 20) { deinitCount += 1 })
        array.append(Person(name: "Anbalagan D", age: 21) { deinitCount += 1 })
        array.append(Person(name: "Swift", age: 22) { deinitCount += 1 })
        
        array.remove(at: array.count - 1)
        #expect(deinitCount == 1)
    }
}
