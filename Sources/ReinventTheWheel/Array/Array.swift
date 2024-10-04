//
//  Array.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

struct UnsafeArray<Element>: Sequence, ExpressibleByArrayLiteral {
    private var storage: ArrayStorage<Element>
    private var current = 0
    
    init() {
        storage = .init()
    }
    
    init(arrayLiteral elements: Element...) {
        storage = .init()
        
        elements.forEach { storage.append($0) }
    }
    
    var count: Int { storage.count }
    
    func append(_ element: Element) {
        storage.append(element)
    }
    
    func insert(at index: Int, value: Element) {
        storage.insert(at: index, value: value)
    }
    
    func remove(at index: Int) {
        storage.remove(at: index)
    }
    
    private func getElement(at index: Int) -> Element {
        storage.getElement(at: index)
    }
    
    func makeIterator() -> UnsafeArrayIterator<Element> {
        UnsafeArrayIterator<Element>(storage)
    }
    
    subscript(index: Int) -> Element {
        get { getElement(at: index) }
        set(newValue) { storage.replace(at: index, value: newValue) }
    }
}

extension UnsafeArray: Collection {
    var startIndex: Int { storage.startIndex }
    
    var endIndex: Int { storage.endIndex }
    
    func index(after i: Int) -> Int { storage.index(after: i) }
}

//TODO: Incomplete
extension UnsafeArray: CustomReflectable {
    var customMirror: Mirror {
        Mirror(reflecting: storage)
    }
}
