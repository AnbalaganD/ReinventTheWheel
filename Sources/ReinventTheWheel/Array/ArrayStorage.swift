//
//  File.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

/// In this class, we do not explicitly verify preconditions.
/// We rely on the UnsafeArray type to guarantee that index-range and other essential preconditions are met.
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
    
    func insert<C: Collection>(at index: Int, collection: C) where C.Element == T {        
        if index == count {
            for element in collection {
                append(element)
            }
        } else {
            var insertIndex = index
            for element in collection {
                insert(at: insertIndex, value: element)
                insertIndex += 1
            }
        }
    }
    
    func replace(at index: Int, value: T) {
        (pointer + index).initialize(to: value)
    }
    
    func getElement(at index: Int) -> T {
        (pointer + index).pointee
    }
    
    @discardableResult
    func remove(at index: Int) -> T {
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
            (pointer + (count - 1)).deinitialize(count: 1)
        }
        
        count -= 1
        return removedElement
    }
    
    func remove(_ range: Range<Int>) {
        let length = range.upperBound - range.lowerBound
        if length == 0 { return }
        
        if range.upperBound == count {
            (pointer + range.lowerBound).deinitialize(count: length)
        } else {
            var oldIndex = range.lowerBound
            repeat {
                (pointer + oldIndex).pointee = (pointer + oldIndex + length).pointee
                oldIndex += 1
            } while oldIndex < (count - length)
            (pointer + (count - length)).deinitialize(count: length)
        }
        
        count -= length
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
    
    func index(before i: Int) -> Int { i - 1 }
    
    func index(after i: Int) -> Int { i + 1 }
    
    func replaceSubrange<C: Collection>(
        _ subrange: Range<Int>,
        with newElements: C
    ) where C.Element == T {
        if newElements is EmptyCollection<T> {
            remove(subrange)
        } else if subrange.lowerBound == subrange.upperBound {
            insert(at: subrange.lowerBound, collection: newElements)
        } else {
            remove(subrange)
            insert(at: subrange.lowerBound, collection: newElements)
        }
    }
    
    private func reallocate(_ pointer: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> {
        defer { pointer.deallocate() }

        capacity *= 2
        let newPointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
        newPointer.initialize(from: pointer, count: count)
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
