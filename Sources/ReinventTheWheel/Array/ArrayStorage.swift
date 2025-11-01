//
//  File.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

/// In this class, we do not explicitly verify preconditions.
/// We rely on the UnsafeArray type to guarantee that index-range and other essential preconditions are met.
@safe final class ArrayStorage<T> {
    private var pointer: UnsafeMutablePointer<T>
    private(set) var capacity = 5
    private(set) var count = 0
    
    init() {
        unsafe pointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
    }
    
    private init(storage: ArrayStorage<T>) {
        capacity = storage.capacity
        count = storage.count
        unsafe pointer = UnsafeMutablePointer<T>.allocate(capacity: storage.capacity)
        unsafe pointer.initialize(from: storage.pointer, count: storage.count)
    }
    
    func append(_ element: T) {
        if count == capacity {
            unsafe pointer = reallocate(pointer)
        }
        
        unsafe (pointer + count).initialize(to: element)
        count += 1
    }
    
    func insert(at index: Int, value: T) {
        if count == capacity {
            unsafe pointer = unsafe reallocate(pointer)
        }
        
        if index == count {
            return append(value)
        }
        
        var currentIndex = count - 1
        repeat {
            unsafe (pointer + currentIndex + 1).initialize(to: getElement(at: currentIndex))
            currentIndex -= 1
        } while currentIndex >= index
        
        unsafe (pointer + index).initialize(to: value)
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
        unsafe (pointer + index).initialize(to: value)
    }
    
    func getElement(at index: Int) -> T {
        unsafe (pointer + index).pointee
    }
    
    @discardableResult
    func remove(at index: Int) -> T {
        let removedElement = unsafe (pointer + index).pointee
        // Remove last element
        if index == count - 1 {
            unsafe (pointer + index).deinitialize(count: 1)
        } else {
            var oldIndex = index
            repeat {
                unsafe (pointer + oldIndex).pointee = (pointer + oldIndex + 1).pointee
                oldIndex += 1
            } while oldIndex < count
            unsafe (pointer + (count - 1)).deinitialize(count: 1)
        }
        
        count -= 1
        return removedElement
    }
    
    func remove(_ range: Range<Int>) {
        let length = range.upperBound - range.lowerBound
        if length == 0 { return }
        
        if range.upperBound == count {
            unsafe (pointer + range.lowerBound).deinitialize(count: length)
        } else {
            var oldIndex = range.lowerBound
            repeat {
                unsafe (pointer + oldIndex).pointee = (pointer + oldIndex + length).pointee
                oldIndex += 1
            } while oldIndex < (count - length)
            unsafe (pointer + (count - length)).deinitialize(count: length)
        }
        
        count -= length
    }
    
    func removeAll(keepingCapacity: Bool = false) {
        if keepingCapacity {
            unsafe pointer.deinitialize(count: count)
        } else {
            // Assign default capacity
            capacity = 5
            unsafe pointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
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
        defer { unsafe pointer.deallocate() }

        capacity *= 2
        let newPointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
        unsafe newPointer.initialize(from: pointer, count: count)
        return unsafe newPointer
    }
    
    deinit {
        unsafe pointer.deallocate()
    }
}

extension ArrayStorage {
    func withUnsafeBufferPointer(_ body: (UnsafeBufferPointer<T>) throws -> Void) rethrows {
        try unsafe body(UnsafeBufferPointer(start: pointer, count: capacity))
    }
}

extension ArrayStorage {
    func makeUniqueCopy() -> ArrayStorage<T> {
        ArrayStorage<T>(storage: self)
    }
}
