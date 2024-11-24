//
//  Dictionary.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

struct UnsafeDictionary<Key: Hashable, Value>: Sequence, ExpressibleByDictionaryLiteral {
    private typealias Bucket = (Key, Value)
    private var buckets: [Bucket?]
    
    init() {
        self.buckets = Array<Bucket?>(repeating: nil, count: 5)
    }
    
    init(dictionaryLiteral elements: (Key, Value)...) {
        self.buckets = Array<Bucket?>(repeating: nil, count: 5)
        for (key, value) in elements {
            self[key] = value
        }
    }
    
    subscript (key: Key) -> Value? {
        get {
            var index = key.hashValue % buckets.capacity
            while buckets[index] != nil && buckets[index]!.0 != key {
                index += 1
            }
            return buckets[index].map(\.1)
        } set(newValue) {
            guard let newValue else {
                var index = abs(key.hashValue % buckets.capacity)
                let startingIndex = index
                while buckets[index] != nil, buckets[index]!.0 != key {
                    index = (index + 1) % buckets.capacity
                    if startingIndex == index {
                        break
                    }
                }
                return buckets[index] = nil
            }
            
            var index = abs(key.hashValue % buckets.capacity)
            let startingIndex = index
            while buckets[index] != nil, buckets[index]!.0 != key {
                index = (index + 1) % buckets.capacity
                if startingIndex == index {
                    //TODO: Implemet reallocation logic here
                    fatalError("Allocate more memory")
                }
            }
            
            buckets[index] = Bucket(key, newValue)
        }
    }
    
    var count: Int { buckets.count }
    
    var capacity: Int { buckets.capacity }
    
    func makeIterator() -> DictionaryIterator<Key, Value> {
        DictionaryIterator(dictionary: self)
    }
    
    fileprivate func getElement(at index: Int) -> (Key, Value)? {
        buckets[index]
    }
}

struct DictionaryIterator<Key: Hashable, Value>: IteratorProtocol {
    var dictionary: UnsafeDictionary<Key, Value>
    
    var current = 0
    mutating func next() -> (Key, Value)? {
        var element = dictionary.getElement(at: current)
        
        while element == nil && current < dictionary.capacity - 1 {
            current += 1
            element = dictionary.getElement(at: current)
        }
        current += 1
        
        return element
    }
}
