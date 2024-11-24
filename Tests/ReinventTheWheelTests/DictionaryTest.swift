//
//  DictionaryTest.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/11/24.
//

import Testing
@testable import ReinventTheWheel

struct DictionaryTest {
    /// To understand the memory safety read below official docs
    /// [Memory safetly](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety/)
    /// and [Exclusivity.cpp](https://github.com/swiftlang/swift/blob/89601448c41d45c1f8213de3f9ce321313f9ad41/stdlib/public/runtime/Exclusivity.cpp)
    
    @Test
    func basic() async throws {
        var dictionary: UnsafeDictionary<String, Int> = [:]
        dictionary["Anbu"] = 1
        dictionary["Anbu D"] = 2
        dictionary["Hi"] = 3
        dictionary["Hello"] = 4
        dictionary["Swift"] = 5
        
        dictionary["Hi"] = nil
        dictionary["Java"] = 6
        
        for (key, value) in dictionary {
            print("\(key): \(value)")
        }
    }
}
