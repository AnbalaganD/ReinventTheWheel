//
//  File.swift
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
    
    private init(storage: ArrayStorage<T>) {
        capacity = storage.capacity
        count = storage.count
        pointer = UnsafeMutablePointer<T>.allocate(capacity: storage.capacity)
        pointer.initialize(from: storage.pointer, count: storage.count)
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
    
    func remove(at index: Int) -> T {
        if index >= count {
            fatalError("Array index out of bound exception")
        }
        
        let removedElement = (pointer + index).pointee
        // Remove last element
        if index == count - 1 {
            (pointer + index).deinitialize(count: 1)
        } else {
            var oldIndex = index
            repeat {
                (pointer + oldIndex).pointee = (pointer + oldIndex + 1).pointee
                oldIndex += 1
            } while oldIndex < count
            (pointer + index).deinitialize(count: 1)
        }
        
        count -= 1
        return removedElement
    }
    
    func removeAll(keepingCapacity: Bool = false) {
        if keepingCapacity {
            pointer.deinitialize(count: count)
        } else {
            // Assign default capacity
            capacity = 5
            pointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
        }
        count = 0
    }
    
    var startIndex: Int { 0 }
    
    var endIndex: Int { count }
    
    func index(before i: Int) -> Int {
        if i >= endIndex { fatalError("After index out of bound exception") }
        return i - 1
    }
    
    func index(after i: Int) -> Int {
        if i >= endIndex { fatalError("After index out of bound exception") }
        return i + 1
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

extension ArrayStorage {
    func withUnsafeBufferPointer(_ body: (UnsafeBufferPointer<T>) throws -> Void) rethrows {
        try body(UnsafeBufferPointer(start: pointer, count: capacity))
    }
}

extension ArrayStorage {
    func makeUniqueCopy() -> ArrayStorage<T> {
        ArrayStorage<T>(storage: self)
    }
}
