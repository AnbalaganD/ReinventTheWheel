//: [Previous](@previous)

import Foundation


struct UnsafeDictionary<Key: Hashable, Value> {
    typealias Bucket = (Key, Value)
    
    private func index(of key: Key) -> Int {
        let dict = [String: Int]()
        dict.capacity
        
        fatalError("Not yet implemented")
    }
}

//var dict = [String: Int]()
//for i in 0 ..< 193 {
//    dict["\(i)"] = i
//}
//print(dict.capacity)
//for i in 0 ..< 193 {
//    dict["\(i)"] = nil
//}
//print(dict.capacity)

var array = [Int]()
for i in 0 ..< 300 {
    array.append(i)
}
print(array.capacity)
for i in 0 ..< 12 {
    array.removeLast()
}
array.removeAll()
print(array.capacity)

//: [Next](@next)
