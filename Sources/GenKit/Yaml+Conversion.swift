//
//  Yaml+Conversion.swift
//  genstrings
//
//  Created by Quinn McHenry on 4/12/17.
//
//

import Yaml

extension Yaml {

    // Converts Yaml instances to standard Swift types

    public func toAny() -> Any {
        switch self {
        case .null:
            return "Null"
        case .bool(let b):
            return b
        case .int(let i):
            return i
        case .double(let f):
            return f
        case .string(let s):
            return s
        case .array(let s):
            return s.map{ $0.toAny() }
        case .dictionary(let m):
            var dict = [String: Any]()
            for (k, v) in m {
                if let k = k.string {
                    dict[k] = v.toAny()
                }
            }
            return dict
        }
    }

}
