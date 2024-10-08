//
//  UniqueLinkedList.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

struct UniqueLinkedList<Key: Hashable, Value>: Sequence, IteratorProtocol {
    private var head: Node<Key, Value>?
    
    private var current: Node<Key, Value>?
    
    mutating func append(key: Key, value: Value) {
        let node = Node.value(key: key, value: value, next: .empty)
        if head == nil {
            head = node
            return
        }
        
        if getValue(for: key) != nil {
            // Already have value for same key
        } else {
            var currentNode = head!
            while case Node.value(_, _, let node) = currentNode {
                
            }
        }
    }
    
    mutating func next() -> Value? {
        guard let head else {
            return nil
        }
        
        guard let currentNode = current else {
            if case Node.value(_, let value, _) = head {
                current = head
                return value
            }
            return nil
        }
        
        if case Node.value(_, _, let node) = currentNode {
            if case Node.value(_, let value, _) = node {
                current = node
                return value
            }
            return nil
        }
        
        return nil
    }
    
    private func getValue(for comparedKey: Key) -> Value? {
        guard let head else {
            return nil
        }
        
        while case Node.value(let key, let value, _) = head {
            if key == comparedKey {
                return value
            }
        }
        
        return nil
    }
}
