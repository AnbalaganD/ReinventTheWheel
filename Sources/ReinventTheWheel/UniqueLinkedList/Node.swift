//
//  Node.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//


indirect enum Node<Key: Hashable, Value> {
    case value(key: Key, value: Value, next: Node<Key, Value>)
    case empty
}