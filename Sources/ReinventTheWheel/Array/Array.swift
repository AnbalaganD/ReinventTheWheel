//
//  Array.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

final class ArrayStorage<T> {
    private var pointer: UnsafeMutablePointer<T>
    private(set) var capacity = 5
    private(set) var count = 0
    
    init() {
        pointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
    }
    
    func append(_ element: T) {
        if count == capacity {
            pointer = reallocate(pointer)
        }
        
        (pointer + count).initialize(to: element)
        count += 1
    }
    
    func insert(at index: Int, value: T) {
        if count == capacity {
            pointer = reallocate(pointer)
        }
        
        if index == count {
            return append(value)
        }
        
        var currentIndex = count - 1
        repeat {
            (pointer + currentIndex + 1).initialize(to: getElement(at: currentIndex))
            currentIndex -= 1
        } while currentIndex >= index
        
        (pointer + index).initialize(to: value)
        count += 1
    }
    
    func replace(at index: Int, value: T) {
        if index >= count {
            fatalError("Array index out of bound exception")
        }
        
        (pointer + index).initialize(to: value)
    }
    
    func getElement(at index: Int) -> T {
        (pointer + index).pointee
    }
    
    //This function is not yet completed
    func remove(at index: Int) {
        if index >= count {
            fatalError("Array index out of bound exception")
        }
        
        // Remove last element
        if index == count - 1 {
            (pointer + index).pointee
        } else {
            //TODO: Remove element at specific path
            var oldIndex = index
            repeat {
                (pointer + oldIndex).pointee = (pointer + oldIndex + 1).pointee
                oldIndex += 1
            } while oldIndex < count - 2
            (pointer + index).deallocate()
        }
        
        var currentIndex = count - 1
        
        count -= 1
    }
    
    func removeAll(keepingCapacity: Bool = false) {
        if keepingCapacity {
            pointer.deinitialize(count: count)
        } else {
            // Assign default capacity
            capacity = 5
            pointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
            count = 0
        }
    }
    
    private func arrange() {
        
    }
    
    private func reallocate(_ pointer: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> {
        defer { pointer.deallocate() }

        capacity *= 2
        let newPointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
        newPointer.update(from: pointer, count: count)
        return newPointer
    }
    
    deinit {
        pointer.deallocate()
    }
}

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
