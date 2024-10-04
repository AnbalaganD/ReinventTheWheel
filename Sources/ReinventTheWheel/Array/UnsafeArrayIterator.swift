//
//  UnsafeArrayIterator.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//


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
