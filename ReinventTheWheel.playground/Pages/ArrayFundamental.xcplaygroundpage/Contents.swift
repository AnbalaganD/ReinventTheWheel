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
    
    func getElement(at index: Int) -> T {
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

do {
    var array = UnsafeArray<Int>()
    array.append(1)
    array.append(2)
    array.append(3)
    array.append(4)
    array.append(5)
    array.append(6)
//    
//    array[1] = "10"
//    print(array[1])
//    array.insert(at: 0, value: "6")
    
//    var array: UnsafeArray<String> = ["1", "2", "3", "4", "5"]
    
    for element in array {
        print(element)
    }
}

print("End of program")
