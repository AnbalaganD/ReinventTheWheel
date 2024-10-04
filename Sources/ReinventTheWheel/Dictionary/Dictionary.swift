//
//  Dictionary.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

struct UnsafeDictionary<Key: Hashable, Value> {
    typealias Bucket = (Key, Value)
    
    private func index(of key: Key) -> Int {
        let dict = [String: Int]()
        dict.capacity
        
        fatalError("Not yet implemented")
    }
}
