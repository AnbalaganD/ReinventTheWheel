//
//  Array.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

struct UnsafeArray<T>: Sequence, ExpressibleByArrayLiteral {
    private var storage: ArrayStorage<T>
    private var current = 0
    
    init() {
        storage = .init()
    }
    
    init(arrayLiteral elements: T...) {
        storage = .init()
        
        elements.forEach {
            storage.append($0)
        }
    }
    
    var count: Int { storage.count }
    
    func append(_ element: T) {
        storage.append(element)
    }
    
    func insert(at index: Int, value: T) {
        storage.insert(at: index, value: value)
    }
    
    func remove(at index: Int) {
        storage.remove(at: index)
    }
    
    private func getElement(at index: Int) -> T {
        storage.getElement(at: index)
    }
    
    func makeIterator() -> some IteratorProtocol {
        UnsafeArrayIterator(storage)
    }
    
    subscript(index: Int) -> T {
        get {
            getElement(at: index)
        }
        set(newValue) {
            storage.replace(at: index, value: newValue)
        }
    }
}

extension UnsafeArray {
    struct UnsafeArrayIterator<Element>: IteratorProtocol {
        private weak var storage: ArrayStorage<Element>?
        private var current = 0
        
        init(_ storage: ArrayStorage<Element>? = nil) {
            self.storage = storage
        }
        
        mutating func next() -> Element? {
            guard let storage else { return nil }
            if storage.count == 0 || current >= storage.count { return nil }
            defer { current += 1 }
            
            return storage.getElement(at: current)
        }
    }
}
