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
        elements.forEach(storage.append)
    }
    
    func append(_ element: Element) {
        storage.append(element)
    }
    
    func insert(at index: Int, value: Element) {
        storage.insert(at: index, value: value)
    }
    
    func remove(at index: Int) {
        storage.remove(at: index)
    }
    
    func makeIterator() -> UnsafeArrayIterator<Element> {
        UnsafeArrayIterator<Element>(storage)
    }
}

extension UnsafeArray: Collection {
    var startIndex: Int { storage.startIndex }
    
    var endIndex: Int { storage.endIndex }
    
    //TODO: check index is valid before read and write
    subscript(position: Int) -> Element {
        get { storage.getElement(at: position) }
        set(newValue) { storage.replace(at: position, value: newValue) }
    }
    
    func index(after i: Int) -> Int { storage.index(after: i) }
}

extension UnsafeArray: BidirectionalCollection {
    func index(before i: Int) -> Int { storage.index(before: i) }
}

//TODO: Incomplete
extension UnsafeArray: CustomReflectable {
    var customMirror: Mirror {
        Mirror(reflecting: storage)
    }
}
