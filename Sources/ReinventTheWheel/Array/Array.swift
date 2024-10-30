//
//  Array.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

struct UnsafeArray<Element>: Sequence, ExpressibleByArrayLiteral {
    private var storage: ArrayStorage<Element>
    
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
    
    func removeAll(keepingCapacity: Bool = false) {
        storage.removeAll(keepingCapacity: keepingCapacity)
    }
    
    func makeIterator() -> UnsafeArrayIterator<Element> {
        UnsafeArrayIterator<Element>(storage)
    }
}

extension UnsafeArray: Collection {
    var startIndex: Int { storage.startIndex }
    
    var endIndex: Int { storage.endIndex }
    
    subscript(position: Int) -> Element {
        get {
            precondition(position >= startIndex, "Position must be positive or zero")
            precondition(position < endIndex, "Index out of bounds")
            return storage.getElement(at: position)
        }
        set(newValue) {
            precondition(position >= startIndex, "Position must be positive or zero")
            precondition(position < endIndex, "Index out of bounds")
            storage.replace(at: position, value: newValue)
        }
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

extension UnsafeArray {
    func withUnsafeBufferPointer(_ body: (UnsafeBufferPointer<Element>) throws -> Void) rethrows {
        try storage.withUnsafeBufferPointer(body)
    }
}

extension UnsafeArray: CustomStringConvertible {
    var description: String {
        var result: String = "["
        for (index, element) in self.enumerated() {
            if index > 0 { result.append(", ") }
            result.append("\(element)")
        }
        result.append("]")
        return result
    }
}
