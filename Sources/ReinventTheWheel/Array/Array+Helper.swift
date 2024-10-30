//
//  Array+Helper.swift
//  ReinventTheWheel
//
//  Created by Anbalagan on 04/10/24.
//

import Foundation

func == <T: Equatable>(lhs: Array<T>, rhs: UnsafeArray<T>) -> Bool {
    if lhs.count != rhs.count { return false }
    return zip(rhs, lhs).allSatisfy { $0 == $1 }
}

func == <T: Equatable>(lhs: UnsafeArray<T>, rhs: Array<T>) -> Bool {
    if lhs.count != rhs.count { return false }
    return zip(rhs, lhs).allSatisfy { $0 == $1 }
}

extension UnsafeArray where Element: Equatable {
    static func == <T: Equatable>(lhs: UnsafeArray<T>, rhs:UnsafeArray<T>) -> Bool {
        if lhs.count != rhs.count { return false }
        return zip(rhs, lhs).allSatisfy { $0 == $1 }
    }
}
