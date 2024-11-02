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
    
    func makeIterator() -> UnsafeArrayIterator<Element> {
        UnsafeArrayIterator<Element>(storage)
    }
    
    private mutating func makeSureIsUniquelyReferenced() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = storage.makeUniqueCopy()
        }
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
            makeSureIsUniquelyReferenced()
            storage.replace(at: position, value: newValue)
        }
    }
    
    func index(after i: Int) -> Int { storage.index(after: i) }
}

extension UnsafeArray: RangeReplaceableCollection {
    mutating func append(_ newElement: Element) {
        makeSureIsUniquelyReferenced()
        storage.append(newElement)
    }
    
    mutating func append<S>(contentsOf newElements: S) where S : Sequence, Element == S.Element {
        fatalError("Not Yet implemented")
    }
    
    mutating func replaceSubrange<C: Collection>(
        _ subrange: Range<Int>,
        with newElements: C
    ) where C.Element == Element {
        fatalError("Not yet implemented")
    }
    
    mutating func insert(_ newElement: Element, at i: Int) {
        precondition(i >= startIndex, "Position must be positive or zero")
        precondition(i < endIndex + 1, "Index out of bounds")
        makeSureIsUniquelyReferenced()
        storage.insert(at: i, value: newElement)
    }
    
    @discardableResult
    mutating func remove(at i: Int) -> Element {
        precondition(i >= startIndex, "Position must be positive or zero")
        precondition(i < endIndex, "Index out of bounds")
        makeSureIsUniquelyReferenced()
        return storage.remove(at: i)
    }
    
    mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        makeSureIsUniquelyReferenced()
        storage.removeAll(keepingCapacity: keepCapacity)
    }
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
